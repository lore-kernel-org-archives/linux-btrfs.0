From: Chester <somethingsome2000@gmail.com>
Subject: btrfs unmountable after failed suspend
Date: Tue, 7 Feb 2012 16:58:49 -0600
Message-ID: <CAAE6i0g4VVpy7FduBHCY33Nt_iSOh39-9i2KWqA0fXETQUKLPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Using stock kernel 3.2.0:

I probably made several mistakes.
1. I'm using zcache which is still staging
2. Tried to suspend to RAM (probably bad with zcache enabled)
3. Using one unified btrfs volume

4. After failing to mount, tried several times to mount with -o recovery

5. Writecache enabled. Though I don't see any messages about barriers
in dmesg, so I assume it's okay.


Fortunately, I was able to come to my senses and boot into initramfs
to get the following dmesg output.

http://pastebin.com/dmNzbH5A

I didn't use any mount options for this (though before, I had
repeatedly used -o recovery).
