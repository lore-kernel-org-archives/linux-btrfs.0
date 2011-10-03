From: Josef Bacik <josef@redhat.com>
Subject: Re: Suddenly, a dead filesystem
Date: Mon, 03 Oct 2011 10:34:51 -0400
Message-ID: <4E89C80B.40601@redhat.com>
References: <CAEbWaipxhyMf2VQRdfnpMcXwyf84YupLOm8hQRf4Q8wJu060ng@mail.gmail.com> <4E53B7DC.7020807@redhat.com> <CAEbWaipUPoO95kbmewfi1j=tBk5gv4Ui6yY8XSOpGHJH9KQpNQ@mail.gmail.com> <CAEbWairrpVkcnDb37O2dF+sQxnmmP7+N2sBd=-pdCNVOH9n8eg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Avi Kivity <avi.kivity@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAEbWairrpVkcnDb37O2dF+sQxnmmP7+N2sBd=-pdCNVOH9n8eg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 09/30/2011 05:40 PM, Avi Kivity wrote:
> On Wed, Aug 24, 2011 at 12:08 AM, Avi Kivity <avi.kivity@gmail.com> wrote:
>>> This is fixed upstream, I've sent the patch to -stable so hopefully it
>>> will show up in fedora soon, but in the meantime can you try Linus's
>>> tree and verify that it fixes it?  Thanks,
>>
>> Thanks, it appears to be fixed (at least in a VM).  Will try native soon.
>>
> 
> It's back.  3.1-rc8:
> 
> 

Thats -EIO, is there any messages before the bug?  Thanks,

Josef
