From: John Wyzer <john.wyzer@gmx.de>
Subject: Re: abysmal performance
Date: Sat, 30 Apr 2011 22:51:05 +0200
Message-ID: <1304196442-sup-4886@localhost>
References: <1304088305-sup-3784@localhost> <1304089239-sup-5110@think> <1304100271-sup-4177@localhost> <1304100862-sup-1493@think> <1304107977-sup-3815@localhost> <1304110058-sup-7292@think> <1304146193-sup-2200@localhost>
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <1304146193-sup-2200@localhost>
List-ID: <linux-btrfs.vger.kernel.org>


Resending this to the list since I did not notice that I just responded to
Chris Mason for the last emails...

Excerpts from John Wyzer's message of Sat Apr 30 08:57:06 +0200 2011:
> Excerpts from Chris Mason's message of Fri Apr 29 22:48:58 +0200 2011:
> > > 
> > > http://bayimg.com/NahClAadn
> > > http://bayimg.com/NahcnaADn
> > > http://bayimg.com/NAhCoAAdN
> > > http://bayimg.com/PahCaaAdN
> > 
> > Ok, you have three processes that may be causing trouble.  We probably
> > just need to defragment the files related to these three and life will
> > be good again.
> > 
> > 1) Firefox.  firefox has a bunch of little databases that are going to
> > fragment badly as we cow. 
> > 
> > 2) sup.  Is this the sup email client?
> > 
> > 3) vmware.  Are you hosting vmware virtual images on btrfs too?
> 
> @2: yes, the sup mail client, polling for messages.
> @3: yes, from some tasks I use vmware
> 
> But those were just the active applications at the time of taking the screenshot.
> I have the same thing with opera or during snapshot deletion or practically
> anything that involves some disk access.
> I'll probably get all atimes for files on my system, sort and defragment the
> files in order of importance...
> We'll see how btrfs behaves afterwards...
