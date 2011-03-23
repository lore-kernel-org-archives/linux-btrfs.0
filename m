From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: cloning single-device btrfs file system onto multi-device one
Date: Wed, 23 Mar 2011 12:13:45 +0700
Message-ID: <AANLkTinUW70Jje41YW6u2EJGiHZ3txK4W3MFRxJmMSsz@mail.gmail.com>
References: <chaz20110321162450.GB918@seebyte.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Stephane Chazelas <stephane.chazelas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <chaz20110321162450.GB918@seebyte.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 21, 2011 at 11:24 PM, Stephane Chazelas
<stephane.chazelas@gmail.com> wrote:
> AFAICT, compression is enabled at mount time and would
> only apply to newly created files. Is there a way to compress
> files already in a btrfs filesystem?

You need to select the files manually (not possible to select a
directory), but yes, it's possible using "btrfs filesystem defragment
-c"

# mount -o loop /tmp/test.img /mnt/tmp
# cd /mnt/tmp
# dd if=/dev/zero of=100M.bin bs=1M count=100;sync;df -h .
100+0 records in
100+0 records out
104857600 bytes (105 MB) copied, 1.20833 s, 86.8 MB/s
Filesystem            Size  Used Avail Use% Mounted on
/dev/loop0            1.0G  101M  794M  12% /mnt/tmp
# /sbin/btrfs fi de -c /mnt/tmp/100M.bin;sync;df -h .
Filesystem            Size  Used Avail Use% Mounted on
/dev/loop0            1.0G  3.5M  891M   1% /mnt/tmp

For a whole filesystem, you might be able to automate it using shell
script with "find . -type f ..."

-- 
Fajar
