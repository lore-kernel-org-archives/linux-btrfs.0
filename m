From: cwillu <cwillu@cwillu.com>
Subject: Re: Kernel 2.6.36 btrfs csum bugreport
Date: Sun, 31 Oct 2010 16:15:29 -0600
Message-ID: <AANLkTi=o2DfaROmy6XONngPxjbWtm5pQjdiE3a+DKdJJ@mail.gmail.com>
References: <vmime.4ccd6740.445d.4b0252c0586bb40@mail.voltage.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <vmime.4ccd6740.445d.4b0252c0586bb40@mail.voltage.de>
List-ID: <linux-btrfs.vger.kernel.org>

> Today while playing around with btrfs I uncovered what must be a bug in the btrfs checksum code. My kernel log received a couple of these messages with various ino and off numbers:
>
> btrfs csum failed ino 5098 off 524288 csum 2981133980 private 959545494
> [..]
>
> This happens on reading from the btrfs filesystem.
>
> The funny thing is that the files are read correct, as verified by md5sum. I have cross-checked this on another machine (with same kernel and btrfs utils): same result. A full filesystem md5sum check showed no errors. The md5sums obviously were computed before the data was copied to the btrfs.
>
> So I conclude that these messages are faulty because data is read correctly. In addition, when you have more than one btrfs you cannot see from the message which fs it is refering to.

Is this a raid1 or a dup array?
