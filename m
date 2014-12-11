Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-08v.sys.comcast.net ([69.252.207.40]:47792 "EHLO
	resqmta-ch2-08v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932261AbaLKJ3a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Dec 2014 04:29:30 -0500
Message-ID: <548963F6.7010703@pobox.com>
Date: Thu, 11 Dec 2014 01:29:26 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Erkki Seppala <flux-btrfs@inside.org>, linux-btrfs@vger.kernel.org
Subject: Re: out of space warning?
References: <CAAe=sHXGpiZN5hKmzv1ynY8x=rH9tMvx86HZP2veLRpAFJN+wg@mail.gmail.com>	<5488F370.2060604@pobox.com> <m49iohiblw2.fsf@coffee.modeemi.fi>
In-Reply-To: <m49iohiblw2.fsf@coffee.modeemi.fi>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/11/2014 01:01 AM, Erkki Seppala wrote:
> Robert White <rwhite@pobox.com> writes:
>
>> You don't check your car's gas tank every time you put your foot on
>> the brake, you don't want to check your free space every time your
>> system finishes every tiny command you type.
>
> Well, actually my car makes a bling every 10 km once it reaches <=80 km
> range, and I don't mind it at all ;-).
>
> As an actual answer, there are monitoring systems that do this, such as
> Icinga (fork of Nagios). In fact, I just recently had the same problem -
> starting a big download might eat up the space and thus terminate the
> download prematurely although I was in position for hours to make up
> more space, so I installed Icinga. Haven't yet configured yet, though,
> so cannot say if it's going to help me :-).
>
> A practical alternative: one could write a script that outputs only the
> amount of free space in a device and add that number to your prompt;
> possibly to your RPROMPT as to now take too much space from your command
> line. Idea extensible to displaying only space from volumes with space
> less than a critical amount etc.
>

I understood exactly what you wanted to do with the prompt script. They 
were quite the rage some time back. I can give you examples off the top 
of my head...

But there are issues and costs.

Lets say you use:

PS1="\$(df --human --output=avail / | tail -1) $ "

You'll end up seeing

106G $

and eventually it will be meaningless. And if you bury it in amongst the 
other prompt stuff. So if I added that to my distro's default prompt and 
made it track the current directory as I moved around...


PS1="\[\033[01;32m\]\u@\h\[\033[01;34m\] \w PS1="\$(df --human 
--output=avail \$PWD | tail -1) \$\[\033[00m\] "

it will fade into the background noise just as fast and pointlessly as 
the rest of the prompt you usually ignore. But now there's a fork and 
exec to pay.

The difference between the prompt thing and your car is that it only 
goes "ding" when you need to pay attention. So now you are putting a 
whole if then thing into the deal.

And you can do that too by defining the PROMPT_COMMAND="whatever". That 
command can do anything "before issuing the prompt" including making 
arbitrary checks and making the speaker go "bing" if you are running low.

And how many filesystems will you be watching?

And if you want btrfs specific stuff (a la btrfs fi show /) you need to 
be root, and I dearly hope you aren't logging into your box as root for 
regular use purposes.

And so on...

There is an old saying "The more you over-think the plumbing, the easier 
it is to stop up the pipes."

If you suffer a system problem (like running out of available ram) and 
your system is thrashing you just deprived yourself of the shell prompt 
because that df command is going to be thrashing along with the rest of it.

So you are correct, there are _lots_ of monitoring methodologies out 
there. KDE, Gnome, and XFCE all provide monitoring widgets that can keep 
you aprised of the current state and fullness of your system storage. 
And they can ring bells and change colors when it gets to alarming 
thresholds.

But doing it to your _prompt_ will get old real fast if you are dealing 
when it matters.




