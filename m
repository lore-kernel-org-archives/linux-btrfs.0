From: Jim <jim@webstarts.com>
Subject: Re: ls hangs filesystem
Date: Tue, 18 Oct 2011 10:08:30 -0400
Message-ID: <4E9D885E.4000602@webstarts.com>
References: <4E9D7E5A.2010403@webstarts.com> <20111018133137.GB4276@localhost.localdomain> <4E9D835F.1010706@webstarts.com> <20111018134926.GA24163@attic.humilis.net> <4E9D873C.8050801@webstarts.com> <20111018140446.GC4276@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: sander@humilis.net, linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111018140446.GC4276@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

Yes, I had thought of that as well but still no output.  Ls has been 
hung for about 30 min now and shows as D+ in ps.  Do you think it would 
get us any information if I forced a reboot and redid the entire 
sequence running sysrq-trigger right after starting ls?
Jim

On 10/18/2011 10:04 AM, Josef Bacik wrote:
> On Tue, Oct 18, 2011 at 10:03:40AM -0400, Jim wrote:
>> I am getting no output from echo 'w'>  /proc/sysrq-trigger.  Ls is
>> hung again so I can try any thing else you suggest to get data.
> Do
>
> echo 1>  /proc/sys/kernel/sysrq
>
> and then try doing the echo w thing.  Thanks,
>
> Josef
