From: "Norbert Scheibner" <scno@gmx.net>
Subject: Re: Freeing space over reboot question
Date: Sat, 11 Feb 2012 14:47:15 +0100
Message-ID: <20120211134715.200530@gmx.net>
References: <20120209174232.318280@gmx.net> <20120210002055.6819f76c@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Cc: linux-btrfs@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120210002055.6819f76c@natsu>
List-ID: <linux-btrfs.vger.kernel.org>

On: Fri, 10 Feb 2012 00:20:55 +0600 Roman Mamedov <rm@romanrm.ru> wrote

> AFAIK the only reliable way currently to ensure the space after a
> subvolume
> deletion is freed, is to remount the FS. 

Have You tried it Yourself? I think the problem was the remount
before the space has been completely freed in background. It
left a valid and working fs, with still work to do.

In my opinion the kernel should either stall the umount till the
space is given free or restart the cleaner after the next mount.

To stall the umount could be annoying and make the user believe
something is broken, because the cleaner could take a while and
it feels to classic for modern fs.

Is there a way to leave an entry in the log to replay after the
next mount? Pardon me if I use the wrong terms here, I'm just
an interested user and not a fs-crack or even a programmer.

Regards
    Norbert
