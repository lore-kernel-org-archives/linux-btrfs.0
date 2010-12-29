From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Bug in ext4/btrfs fallocate?
Date: Tue, 28 Dec 2010 23:46:39 -0700
Message-ID: <6A86E6B8-E14E-484B-BBF5-F3C580337661@dilger.ca>
References: <4D1A0B1C.70406@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	tytso@mit.edu, chris.mason@oracle.com
To: Marco Stornelli <marco.stornelli@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <4D1A0B1C.70406@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 2010-12-28, at 09:06, Marco Stornelli wrote:
> it seems that ext4/btrfs code for fallocate doesn't check for
> immutable/append inode flag.

fallocate() probably shouldn't be allowed for immutable files, but it makes a lot of sense to call fallocate() on append-only files to avoid fragmentation, though it should only be called with the KEEP_SIZE flag.

Cheers, Andreas





