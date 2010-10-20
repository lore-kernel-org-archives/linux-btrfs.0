From: Felix Blanke <felixblanke@gmail.com>
Subject: Re: newbie question about inode numbers
Date: Wed, 20 Oct 2010 15:55:32 +0200
Message-ID: <4CBEF4D4.7000805@gmail.com>
References: <AANLkTinE03sBL=K3xfL41VZyFLhafNxHooheTv1PSQTD@mail.gmail.com> <AANLkTimHQfszXJs9wEff-j9L4+kcOaG385qACK0wzkLs@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
To: David Nicol <davidnicol@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimHQfszXJs9wEff-j9L4+kcOaG385qACK0wzkLs@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Which is a really good thing!

HTML e-mails are useless and nobody should use them! I'm sure they came 
directly from hell.


David Nicol schrieb:
> Wow, vger categorically refuses HTML e-mail!
> 
> On Tue, Oct 19, 2010 at 4:41 PM, David Nicol <davidnicol@gmail.com> wrote:
>> the inode number is an "unsigned long" which on a 32 bit system may be merely 32 bits, yet btrfs allows a full 64 bits of files in a file system (which is impossible; but ZFS allows 128 bits of files, which is just silly.)
>> My question is, how are inode number collisions prevented on a 32-bit system, with a fs with five billion files?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

