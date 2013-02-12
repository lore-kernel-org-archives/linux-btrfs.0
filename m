Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60383 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932306Ab3BLQjn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Feb 2013 11:39:43 -0500
Date: Tue, 12 Feb 2013 17:39:38 +0100
From: David Sterba <dsterba@suse.cz>
To: Ian Kumlien <pomac@demius.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/6] Btrfs-progs: add btrfsck functionality to btrfs
Message-ID: <20130212163938.GA12339@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1360283822-23452-1-git-send-email-pomac@demius.net>
 <1360283822-23452-3-git-send-email-pomac@demius.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1360283822-23452-3-git-send-email-pomac@demius.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 08, 2013 at 01:36:58AM +0100, Ian Kumlien wrote:
> -btrfsck: $(objects) btrfsck.o
> -	@echo "    [LD]     $@"
> -	$(Q)$(CC) $(CFLAGS) -o btrfsck btrfsck.o $(objects) $(LDFLAGS) $(LIBS)
> -

Do we want to get rid of the btrfsck binary completely? Using the term
'btrsfck' is common and anybody compiling sources from git needs to cp
or ln btrfs -> btrfsck. Let's make it automatic, I'll add a makefile
rule:

--- a/Makefile
+++ b/Makefile
@@ -42,7 +42,7 @@ endif

 MAKEOPTS = --no-print-directory Q=$(Q)

-progs = btrfsctl mkfs.btrfs btrfs-debug-tree btrfs-show btrfs-vol \
+progs = btrfsctl mkfs.btrfs btrfs-debug-tree btrfs-show btrfs-vol btrfsck \
        btrfs btrfs-map-logical btrfs-image btrfs-zero-log btrfs-convert \
        btrfs-find-root btrfstune btrfs-show-super

@@ -125,6 +125,11 @@ btrfs-show: $(objects) $(libs) btrfs-show.o
        @echo "    [LD]     $@"
        $(Q)$(CC) $(CFLAGS) -o btrfs-show btrfs-show.o $(objects) $(LDFLAGS) $(LIBS)

+# For backward compatibility, 'btrfs' changes behaviour to fsck if it's named 'btrfsck'
+btrfsck: btrfs
+       @echo "    [CP]     $@"
+       $(Q)cp btrfs btrfsck
+
 mkfs.btrfs: $(objects) $(libs) mkfs.o
        @echo "    [LD]     $@"
        $(Q)$(CC) $(CFLAGS) -o mkfs.btrfs $(objects) mkfs.o $(LDFLAGS) $(LIBS) -lblkid
@@ -186,7 +191,7 @@ install-man:
 clean :
        @echo "Cleaning"
        $(Q)rm -f $(progs) cscope.out *.o .*.d btrfs-convert btrfs-image btrfs-select-super \
-             btrfs-zero-log btrfstune dir-test ioctl-test quick-test btrfs.static \
+             btrfs-zero-log btrfstune dir-test ioctl-test quick-test btrfs.static btrfsck \
              version.h \
              $(libs) libbtrfs.so libbtrfs.so.0 libbtrfs.so.0.1
        $(Q)$(MAKE) $(MAKEOPTS) -C man $@
---

david
