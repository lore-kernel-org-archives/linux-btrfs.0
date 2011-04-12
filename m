From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: [PATCH] mark internal functions static
Date: Tue, 12 Apr 2011 09:30:42 +0800
Message-ID: <BANLkTimM3dsPxp+oFJuK7JX8iSJRd=BBtA@mail.gmail.com>
References: <BANLkTinUKcSNp_TN8FaE8Tiy-VX=F+v03Q@mail.gmail.com>
	<4DA32231.5000806@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux BTRFS <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DA32231.5000806@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 11 April 2011 23:45, Josef Bacik <josef@redhat.com> wrote:
> On 04/11/2011 11:40 AM, Daniel J Blueman wrote:
>>
>> Hi Chris,
>>
>> This didn't make it in before, so updating to 2.6.39-rc2 and resendi=
ng:
>>
>> Prevent needless exporting of internal functions from compilation
>> units by marking them static.
>>
>
> Looks like you have line wrapping on or something, the page looks man=
gled.
> =A0Thanks,

The only way I can solve this in gmail webmail is by attaching the patc=
h.

Is this acceptable? I guess if the mailing list strips patches, I
guess using both may be a get-out-of-jail...

Daniel
--=20
Daniel J Blueman
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
