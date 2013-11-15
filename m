Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:58561 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915Ab3KOLdk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Nov 2013 06:33:40 -0500
Received: from /spool/local
	by e06smtp14.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <heiko.carstens@de.ibm.com>;
	Fri, 15 Nov 2013 11:33:38 -0000
Date: Fri, 15 Nov 2013 12:32:16 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Chris Mason <chris.mason@fusionio.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [GIT PULL] Btrfs
Message-ID: <20131115113216.GA7777@osiris>
References: <20131114171952.3802.93244@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131114171952.3802.93244@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 14, 2013 at 12:19:52PM -0500, Chris Mason wrote:
> Hi Linus,
> 
> Please pull my for-linus branch:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus
> 
> This is our usual merge window set of bug fixes, performance
> improvements and cleanups.  Miao Xie has some really nice optimizations
> for writeback.
> 
> Josef also expanded our sanity checks quite a bit; these make up a big
> chunk of the new lines.

Hmm..  b19e68439375  "btrfs: Remove redundant local zero structure" seems to
use the empty_zero_page incorrectly and causes this compile warning on s390:

  CC      fs/btrfs/ioctl.o
fs/btrfs/ioctl.c: In function 'btrfs_is_empty_uuid':
fs/btrfs/ioctl.c:372:2: warning: passing argument 2 of 'memcmp' makes pointer from
                        integer without a cast [enabled by default]
  return !memcmp(uuid, empty_zero_page, BTRFS_UUID_SIZE);
  ^

In fact there seem to be two more incorrect usages in the kernel. The patch
below is not really tested.


>From c2a9d3a453629466f0528aacbc6cbecc4247cff5 Mon Sep 17 00:00:00 2001
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Fri, 15 Nov 2013 12:14:55 +0100
Subject: [PATCH] fix empty_zero_page misusage

The definition of empty_zero_page is architecture specific.
It is (currently) either a character array, an unsigned long containing
the address of the empty_zero_page, or even worse only the address
of the struct page belonging to the empty_zero_page.

So using empty_zero_page as source address to e.g. clear something may
give random results.
ZERO_PAGE() however returns across all architectures the pointer to
the struct page belonging to the empty_zero_page.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 drivers/spi/spi-fsl-cpm.c | 3 ++-
 fs/btrfs/ioctl.c          | 4 +++-
 virt/kvm/kvm_main.c       | 5 +++--
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-fsl-cpm.c b/drivers/spi/spi-fsl-cpm.c
index 54b06376f03c..3807bbf8a48f 100644
--- a/drivers/spi/spi-fsl-cpm.c
+++ b/drivers/spi/spi-fsl-cpm.c
@@ -280,6 +280,7 @@ static unsigned long fsl_spi_cpm_get_pram(struct mpc8xxx_spi *mspi)
 
 int fsl_spi_cpm_init(struct mpc8xxx_spi *mspi)
 {
+	const void *zero_page = (const void *) page_to_phys(ZERO_PAGE(0));
 	struct device *dev = mspi->dev;
 	struct device_node *np = dev->of_node;
 	const u32 *iprop;
@@ -324,7 +325,7 @@ int fsl_spi_cpm_init(struct mpc8xxx_spi *mspi)
 		goto err_bds;
 	}
 
-	mspi->dma_dummy_tx = dma_map_single(dev, empty_zero_page, PAGE_SIZE,
+	mspi->dma_dummy_tx = dma_map_single(dev, zero_page, PAGE_SIZE,
 					    DMA_TO_DEVICE);
 	if (dma_mapping_error(dev, mspi->dma_dummy_tx)) {
 		dev_err(dev, "unable to map dummy tx buffer\n");
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 1d04b5559e61..83f2b3e4fbf0 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -368,8 +368,10 @@ static noinline int btrfs_ioctl_fitrim(struct file *file, void __user *arg)
 
 int btrfs_is_empty_uuid(u8 *uuid)
 {
+	const void *zero_page = (const void *) page_to_phys(ZERO_PAGE(0));
+
 	BUILD_BUG_ON(BTRFS_UUID_SIZE > PAGE_SIZE);
-	return !memcmp(uuid, empty_zero_page, BTRFS_UUID_SIZE);
+	return !memcmp(uuid, zero_page, BTRFS_UUID_SIZE);
 }
 
 static noinline int create_subvol(struct inode *dir,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 662f34c3287e..01edf1c19332 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1615,8 +1615,9 @@ EXPORT_SYMBOL_GPL(kvm_read_guest_cached);
 
 int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len)
 {
-	return kvm_write_guest_page(kvm, gfn, (const void *) empty_zero_page,
-				    offset, len);
+	const void *zero_page = (const void *) page_to_phys(ZERO_PAGE(0));
+
+	return kvm_write_guest_page(kvm, gfn, zero_page, offset, len);
 }
 EXPORT_SYMBOL_GPL(kvm_clear_guest_page);
 
-- 
1.8.3.4

