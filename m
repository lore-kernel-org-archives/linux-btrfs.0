From: Avi Kivity <avi.kivity@gmail.com>
Subject: Re: Suddenly, a dead filesystem
Date: Mon, 3 Oct 2011 17:12:45 +0200
Message-ID: <CAEbWair966=m=4Fe_ipZNJk5PB381t_1gJ+TYPZ_naP8s=eJsw@mail.gmail.com>
References: <CAEbWaipxhyMf2VQRdfnpMcXwyf84YupLOm8hQRf4Q8wJu060ng@mail.gmail.com>
	<4E53B7DC.7020807@redhat.com>
	<CAEbWaipUPoO95kbmewfi1j=tBk5gv4Ui6yY8XSOpGHJH9KQpNQ@mail.gmail.com>
	<CAEbWairrpVkcnDb37O2dF+sQxnmmP7+N2sBd=-pdCNVOH9n8eg@mail.gmail.com>
	<4E89C80B.40601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E89C80B.40601@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 3, 2011 at 4:34 PM, Josef Bacik <josef@redhat.com> wrote:
> On 09/30/2011 05:40 PM, Avi Kivity wrote:
>> On Wed, Aug 24, 2011 at 12:08 AM, Avi Kivity <avi.kivity@gmail.com> =
wrote:
>>>> This is fixed upstream, I've sent the patch to -stable so hopefull=
y it
>>>> will show up in fedora soon, but in the meantime can you try Linus=
's
>>>> tree and verify that it fixes it? =A0Thanks,
>>>
>>> Thanks, it appears to be fixed (at least in a VM). =A0Will try nati=
ve soon.
>>>
>>
>> It's back. =A03.1-rc8:
>>
>>
>
> Thats -EIO, is there any messages before the bug? =A0Thanks,
>

Not that I recall.  I'll check again when I'm near the poor thing again=
=2E
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
