From: cwillu <cwillu@cwillu.com>
Subject: Re: Kernel 2.6.36 btrfs csum bugreport
Date: Mon, 1 Nov 2010 05:02:10 -0600
Message-ID: <AANLkTinjCa_7cDuY0AMypswssN4L73WMffuA6-mEWgde@mail.gmail.com>
References: <vmime.4cce0b42.4e03.7a6f42ce1e8ae262@mail.voltage.de>
	<AANLkTim3QfhFVvPaiKMSJPSjuRhG89=+DH63NsJf+SfH@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andreas Bauer <ab@voltage.de>, linux-btrfs@vger.kernel.org
To: Daniel J Blueman <daniel.blueman@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTim3QfhFVvPaiKMSJPSjuRhG89=+DH63NsJf+SfH@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 1, 2010 at 4:55 AM, Daniel J Blueman
<daniel.blueman@gmail.com> wrote:
> On 1 November 2010 00:35, Andreas Bauer <ab@voltage.de> wrote:
>> So I conclude that these messages are faulty because data is read co=
rrectly.
>> =A0In addition, when you have more than one btrfs you cannot see fro=
m the message
>> =A0which fs it is refering to.
>>
>> =A0Is this a raid1 or a dup array?
>>
>> No, plain vanilla partition on physical hard disk. Btrfs was made wi=
th the command "mkfs.btrfs /dev/sdc1" no extra arguments.
>
> By default, metadata is duplicated, thus it could be that BTRFS is
> using the correct copy of the metadata after finding checksum errors
> in the first copy.

Ahhhhhhh, and that makes this make sense:

Andreas, have you checked which file(s) are giving the errors?  if
not, you can use "find /whatever/mountpoint -xdev -inum 5098 -print"
to get the filename.  And I would bet that it's small enough that it's
being inlined into the metadata block group, and therefore covered
under the default "dup" profile of that block group, which is why
you're getting the actual file data back.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
