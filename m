From: Calvin Walton <calvin.walton@gmail.com>
Subject: Re: Misleading error message in btrfsctl
Date: Sun, 18 Jan 2009 09:12:30 -0500
Message-ID: <1232287950.10058.6.camel@trillian>
References: <49733138.4010309@aon.at>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Peter Klotz <peter.klotz@aon.at>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49733138.4010309@aon.at>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2009-01-18 at 14:40 +0100, Peter Klotz wrote:
> Calling btrfsctl results in this message when module btrfs.ko is not loaded:
> 
> root@asus:/root# btrfsctl -A /dev/sda
> ioctl:: Bad file descriptor
..
> The output with applied patch:
> 
> root@asus:/root# btrfsctl -A /dev/sda
> failed to open /dev/btrfs-control

It would probably be better to use perror() instead of fprintf, in order
to give the actual error message. I often find it useful to know why the
device failed to open - is it missing, permission issues? I've updated
the patch:

diff --git a/btrfsctl.c b/btrfsctl.c
index e049799..df1a165 100644
--- a/btrfsctl.c
+++ b/btrfsctl.c
@@ -189,6 +189,10 @@ int main(int ac, char **av)
 
 	if (command == BTRFS_IOC_SCAN_DEV) {
 		fd = open("/dev/btrfs-control", O_RDWR);
+		if (fd < 0) {
+			perror("failed to open /dev/btrfs-control");
+			exit(1);
+		}
 		name = fname;
 	 } else {
 		fd = open_file_or_dir(fname);

-- 
Calvin Walton <calvin.walton@gmail.com>

