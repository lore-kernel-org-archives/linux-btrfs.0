From: "Lee Trager" <lt73@cs.drexel.edu>
Subject: Selective Compression/Encryption
Date: Tue, 9 Dec 2008 09:59:52 -0500
Message-ID: <20081209145952.GA30494@tux64-03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Currently compression and I assume if encryption is implemented it is
turned on or off during mount. There are however many times when a user may
want to select which files/directories they want to compress or encrypt.
This will also be helpful when implementing btrfs support in grub for
example. We can say the disk can be compressed/encrypted except for /boot so 
compression/encryption doesn't have to be implemented in grub.

I was thinking of adding this functionality to the userspace application
btrfstune. The way I was thinking of doing this is when btrfstune +c is
applied to a directory or file the directory(and all its contents) or
file will always be compressed reguardless of how the filesystem is
mounted. The opposite would happen when btrfstune -c is used.

Would this be a reasonable thing to implement? Any suggestions before I
start doing this?

Lee
