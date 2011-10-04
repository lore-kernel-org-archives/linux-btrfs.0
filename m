From: Josef Bacik <josef@redhat.com>
Subject: Re: Suddenly, a dead filesystem
Date: Tue, 04 Oct 2011 15:41:32 -0400
Message-ID: <4E8B616C.1030103@redhat.com>
References: <CAEbWaipxhyMf2VQRdfnpMcXwyf84YupLOm8hQRf4Q8wJu060ng@mail.gmail.com> <4E53B7DC.7020807@redhat.com> <CAEbWaipUPoO95kbmewfi1j=tBk5gv4Ui6yY8XSOpGHJH9KQpNQ@mail.gmail.com> <CAEbWairrpVkcnDb37O2dF+sQxnmmP7+N2sBd=-pdCNVOH9n8eg@mail.gmail.com> <4E89C80B.40601@redhat.com> <CAEbWair966=m=4Fe_ipZNJk5PB381t_1gJ+TYPZ_naP8s=eJsw@mail.gmail.com> <CAEbWaio2+c9iNjkQYnQv+=UKdR5=zpMne40RCa2X2wBObfJnxw@mail.gmail.com> <CAEbWaiqrcDQUN+7-Yg3QJwJPUcxFK5br08rKkwuuRQy_x9_k6A@mail.gmail.com> <CAEbWaioOMeVeACT4wMceP=obyjwrNGd7H8Rs77QrC1d=iCSgqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Avi Kivity <avi.kivity@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAEbWaioOMeVeACT4wMceP=obyjwrNGd7H8Rs77QrC1d=iCSgqA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 10/04/2011 03:40 PM, Avi Kivity wrote:
> On Tue, Oct 4, 2011 at 4:39 PM, Avi Kivity <avi.kivity@gmail.com> wrote:
>> On Mon, Oct 3, 2011 at 8:07 PM, Avi Kivity <avi.kivity@gmail.com> wrote:
>>>>>
>>>>> Thats -EIO, is there any messages before the bug?  Thanks,
>>>>>
>>>>
>>>> Not that I recall.  I'll check again when I'm near the poor thing again.
>>>>
>>>
>>> Confirmed - that's the first relevant message.
>>>
>>> As to -EIO, I dd'ed the entire volume and no errors were found.
>>>
>>
>> btw, is there a new version of fsck.btrfs I can try?  The one I have
>> segfaults immediately.
>>
> 
> Meanwhile, I used btrfs-zero-log and was able to remount.  I have a
> snapshot of the dead filesystem, if someone wants to investigate.

Yup I would love to investigate this, what kind of snapshot?  Did you dd
the drive or soemthing?  Let me know where to pull it down.  Thanks,

Josef
