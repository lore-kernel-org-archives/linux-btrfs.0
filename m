From: Josef Bacik <josef@redhat.com>
Subject: Re: kernel BUG at fs/btrfs/extent_io.c:1890!
Date: Thu, 12 Apr 2012 14:08:37 -0400
Message-ID: <20120412180836.GJ1924@localhost.localdomain>
References: <CACfQV3hb92zrYUJ8to1mq8s1wzfdEoMBDi9b5VmfZ0AZ=UBkFA@mail.gmail.com>
 <20120411150158.GA5820@localhost.localdomain>
 <CACfQV3j_WGTB-+booc1bDMvs1i_Kjr_WAAmLKgUb9sUWe-+wPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Francesco Cepparo <francesco.cepparo@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CACfQV3j_WGTB-+booc1bDMvs1i_Kjr_WAAmLKgUb9sUWe-+wPg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 11, 2012 at 11:59:43PM +0000, Francesco Cepparo wrote:
> I tried your patch but unfortunately the kernel still gives me the
> same error message :(
 
Weird, will you apply this patch on top of the one I sent you and send me the
dmesg when it panics again?  Thanks,

Josef

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2a3ddd2..51efb58 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -652,6 +652,8 @@ static int btree_io_failed_hook(struct page *page, int failed_mirror)
 
 	eb = (struct extent_buffer *)page->private;
 	set_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
+	WARN_ON(!failed_mirror);
+	printk(KERN_ERR "io error, failed mirror %d\n");
 	eb->failed_mirror = failed_mirror;
 	if (test_and_clear_bit(EXTENT_BUFFER_READAHEAD, &eb->bflags))
 		btree_readahead_hook(root, eb, eb->start, -EIO);
