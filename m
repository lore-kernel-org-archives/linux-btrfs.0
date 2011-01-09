From: Alan Chandler <alan@chandlerfamily.org.uk>
Subject: Re: Synching a Backup Server
Date: Sun, 09 Jan 2011 23:32:20 +0000
Message-ID: <4D2A4584.4020901@chandlerfamily.org.uk>
References: <201101060935.14059.CACook@quantum-sci.com> <201101061342.23991.CACook@quantum-sci.com> <AANLkTimOEsFiF7tiCzV-Y3NfGYHjK+uL_3O6PNDKum90@mail.gmail.com> <201101071720.08298.hka@qbs.com.pl> <4D29A033.7000803@chandlerfamily.org.uk> <AANLkTi=KASX7pFO8dxJ1P=OhP3qj6qjTgtA6g1Fw-ou4@mail.gmail.com> <4D29D508.6080006@chandlerfamily.org.uk> <AANLkTim96P3ZD-WpDonsOHB7aicNBQX-wK6v347r1z8s@mail.gmail.com> <20110109183030.GA29572@carfax.org.uk> <4D2A2128.2060508@chandlerfamily.org.uk> <20110109220101.GB29572@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Hugo Mills <hugo-lkml@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110109220101.GB29572@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On 09/01/11 22:01, Hugo Mills wrote:
>>   I find the wiki
>> also confusing because it talks about subvolumes having to be at the
>> first level of the filesystem, but again further up this thread
>> there is an example which is used for real of it not being at the
>> first level, but at one level down inside a directory.
>
>     Try it, see what happens, and fix the wiki where it's wrong? :)
>
>     Or at least say what page this is on, and I can try the experiment
> and fix it later...
I don't have an account right now, but the page its on is here.

https://btrfs.wiki.kernel.org/index.php/Getting_started#Basic_Filesystem_Commands

...
>      From trying it a while ago, I don't think it is possible to create
> a filesystem in degraded mode. Again, I'll try it again when I have
> the time to do some experimentation and see what actually happens.

As I wondered before it might be possible to fake it by using something 
like a USB stick initially and then failing it, and replacing it with 
the real device when ready.

If thats possible, then perhaps functionality to do it without faking it 
could be added to the "to do" list. It sure would be useful in migrating 
from mdmadm/lvm setup.


-- 
Alan Chandler
http://www.chandlerfamily.org.uk
