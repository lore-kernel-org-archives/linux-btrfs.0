From: Eric Griffith <egriffith92@gmail.com>
Subject: Re: How to remount btrfs without compression?
Date: Mon, 07 Nov 2011 20:54:17 -0500
Message-ID: <4EB88BC9.7020509@gmail.com>
References: <4EB72C1B.1030702@parallels.com> <201111071319.14493.Martin@lichtvoll.de> <4EB87E01.1040704@parallels.com> <4EB880A0.1030304@gmail.com> <CAG1y0seMUUNwXCY6-=JehE+rrd4PRF55MZoHEUB_9+jDm6N_rA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0seMUUNwXCY6-=JehE+rrd4PRF55MZoHEUB_9+jDm6N_rA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 11/7/2011 8:52 PM, Fajar A. Nugraha wrote:
> On Tue, Nov 8, 2011 at 8:06 AM, Eric Griffith<egriffith92@gmail.com>  wrote:
>> Edit your
>> fstab, remove the compress flag, reboot. Tell btrfs to rebalance the system,
>> reboot again. And I -THINK- that'll decompress all the files
>
> I think the original question was how to force uncompressed mode,
> whether specific to a file or to a whole filesystem, without having to
> reboot :)
>
> AFAIK there's no way to do that.
>

Whoops! Misunderstood the question haha. Yeah, as far as decompressing 
just a single file; from what I've read, thats impossible.
