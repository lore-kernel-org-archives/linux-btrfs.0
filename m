From: Josef Bacik <josef@redhat.com>
Subject: Re: Suddenly, a dead filesystem
Date: Tue, 04 Oct 2011 16:01:06 -0400
Message-ID: <4E8B6602.8000005@redhat.com>
References: <CAEbWaipxhyMf2VQRdfnpMcXwyf84YupLOm8hQRf4Q8wJu060ng@mail.gmail.com> <4E53B7DC.7020807@redhat.com> <CAEbWaipUPoO95kbmewfi1j=tBk5gv4Ui6yY8XSOpGHJH9KQpNQ@mail.gmail.com> <CAEbWairrpVkcnDb37O2dF+sQxnmmP7+N2sBd=-pdCNVOH9n8eg@mail.gmail.com> <4E89C80B.40601@redhat.com> <CAEbWair966=m=4Fe_ipZNJk5PB381t_1gJ+TYPZ_naP8s=eJsw@mail.gmail.com> <CAEbWaio2+c9iNjkQYnQv+=UKdR5=zpMne40RCa2X2wBObfJnxw@mail.gmail.com> <CAEbWaiqrcDQUN+7-Yg3QJwJPUcxFK5br08rKkwuuRQy_x9_k6A@mail.gmail.com> <CAEbWaioOMeVeACT4wMceP=obyjwrNGd7H8Rs77QrC1d=iCSgqA@mail.gmail.com> <4E8B616C.1030103@redhat.com> <CAEbWairdtBX9Rf4XyOreO4BVXp4B0fswKcGw69osj8R6ZGbgsA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Avi Kivity <avi.kivity@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAEbWairdtBX9Rf4XyOreO4BVXp4B0fswKcGw69osj8R6ZGbgsA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 10/04/2011 03:50 PM, Avi Kivity wrote:
>> Yup I would love to investigate this, what kind of snapshot?
> 
> LVM snapshot.
> 
>> Did you dd
>> the drive or soemthing?  Let me know where to pull it down.
> 
> Um, it's my /home.  It's not leaving home.  But if you have test
> kernels or btrfscks you want to throw at it, I'm happy to help.

Hah well you can run btrfs-image -c <0-9> -t <number of threads> on your
device it will create a image of the broken fs for me to look at and
doesn't copy any of the data and zero's out any inline extents, the only
thing I'll potentially would be able to see is the file names.  If
that's acceptable just upload it somewhere for me to pull down.  If not
I'll put together a debug patch for you to try out.  Thanks,

Josef
