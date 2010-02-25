From: Leszek Ciesielski <skolima@gmail.com>
Subject: Re: btrfs no csum found for inode X start 0
Date: Thu, 25 Feb 2010 21:52:47 +0100
Message-ID: <23a15591002251252w5b35e761t5311f3bd569b9d41@mail.gmail.com>
References: <23a15591002242352r665ffddax479d4cbfd8c88cdb@mail.gmail.com>
	 <23a15591002250134m753cd437jb14e320d2e8b39b3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <23a15591002250134m753cd437jb14e320d2e8b39b3@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

I have changed the btrfs code to ignore checksum failures and now I
can read files correctly from the filesystem. Also, moving them onto
another volume and then back into btrfs fixes the checksums and no
more errors are reported for the file in question.

Quick and dirty code I used for getting my files out:

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index a11a320..d6e6aa9 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -140,8 +140,9 @@ static int check_compressed_csum(struct inode *inode,
                               "wanted %u mirror %d\n", inode->i_ino,
                               (unsigned long long)disk_start,
                               csum, *cb_sum, cb->mirror_num);
-                       ret = -EIO;
-                       goto fail;
+                       /*ret = -EIO;
+                       goto fail;*/
+                       printk("btrfs ignoring compressed csum mismatch");
                }
                cb_sum++;

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4deb280..f1572ce 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1955,8 +1955,9 @@ static int btrfs_readpage_end_io_hook(struct
page *page, u64 start, u64 end,

        csum = btrfs_csum_data(root, kaddr + offset, csum,  end - start + 1);
        btrfs_csum_final(csum, (char *)&csum);
-       if (csum != private)
-               goto zeroit;
+       if (csum != private && printk_ratelimit())
+               printk(KERN_INFO "btrfs ignoring csum mismatch");
+//             goto zeroit;

        kunmap_atomic(kaddr, KM_USER0);
 good:


On Thu, Feb 25, 2010 at 10:34 AM, Leszek Ciesielski <skolima@gmail.com> wrote:
> (My previous post seems to have been discarded because of the
> attachment size, I'm resending it without the dmesg output - which can
> be found @ http://pastebin.com/T0J3z59j )
>
> Hi,
>
> yesterday I updated my kernel (clean clone from
> mason/btrfs-unstable.gi), pulling in the single latest change I have
> been missing ( http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable.git;a=commit;h=3f6fae9559225741c91f1320090b285da1413290
> ) and adding my patch from http://patchwork.kernel.org/patch/81547/ .
> Previous kernel version (without my patch - could this be my fault?)
> has been running fine for 14 days, but after recompiling and
> rebooting, my dmesg output is full of "btrfs no csum found for inode
> 386 start 0" and "btrfs csum failed ino 386 extent 65191274496 csum
> 1851253866 wanted 0 mirror 1" and "btrfs csum failed ino 82619 off
> 8749056 csum 2686054019 private 0", repeating with different values.
> Also, accessing pretty much any file ends with "read error" - only
> small text files remained readable. Newly written files seem to behave
> correctly. I have tried reverting back to the version from 10.02.2010
> (last change on 04.02, without my patch) that worked well before, but
> now it also spits out the same errors and files remain unreadable.
> Dmesg output is attached. Anything more I can do to help diagnose the
> problem?
>
> Regards,
>
> Leszek 'skolima' Ciesielski
>
