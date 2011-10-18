From: Jim <jim@webstarts.com>
Subject: Re: ls hangs filesystem
Date: Tue, 18 Oct 2011 10:03:40 -0400
Message-ID: <4E9D873C.8050801@webstarts.com>
References: <4E9D7E5A.2010403@webstarts.com> <20111018133137.GB4276@localhost.localdomain> <4E9D835F.1010706@webstarts.com> <20111018134926.GA24163@attic.humilis.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: sander@humilis.net
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111018134926.GA24163@attic.humilis.net>
List-ID: <linux-btrfs.vger.kernel.org>

I am getting no output from echo 'w' > /proc/sysrq-trigger.  Ls is hung 
again so I can try any thing else you suggest to get data.
Jim

On 10/18/2011 09:49 AM, Sander wrote:
> Jim wrote (ao):
>> I am on kernel 3.1.0-rc4.  I am ssh'd into a remote machine so have
>> no access to keyboard, any other way to get the info you need?
> echo 'w'>  /proc/sysrq-trigger
>
>
>> On 10/18/2011 09:31 AM, Josef Bacik wrote:
>>> On Tue, Oct 18, 2011 at 09:25:46AM -0400, Jim wrote:
>>>> Good morning btrfs list,
>>>> I have been rsyncing files from an nfs mount to a btrfs filesystem.
>>>> After an rsync run I ls random subvols or directorys to check the
>>>> copy.  About 60% to 70% of the time ls completely hangs.  Ps aux
>>>> shows it as running but even when I let it go for up to an hour it
>>>> never finishes.  Kill -9 will not stop the process.  Dmesg shows
>>>> nothing beyond a successful mount at boot.  I can't umount the
>>>> system because "filesystem is busy".  I find that a forced reboot is
>>>> the only way to recapture the system.  /var/log/messages has the
>>>> only indication (that I can find) that anything abnormal is
>>>> happening.  A tail of the file is below.  Thank you for any help and
>>>> advice.
>>> Hit sysrq+w when this happens and give us all the tracebacks.  Also which kernel
>>> you are on would be helpful.  Thanks,
>>>
>>> Josef
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
