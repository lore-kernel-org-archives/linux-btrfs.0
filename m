From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Should i use btrfs?
Date: Tue, 27 May 2008 13:03:43 -0400
Message-ID: <200805271303.44428.chris.mason@oracle.com>
References: <1211898349.9189.21.camel@bitch>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Cc: linux-btrfs@vger.kernel.org
To: Darko Hojnik <btrfs@virtualizing.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1211898349.9189.21.camel@bitch>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 27 May 2008, Darko Hojnik wrote:
> Yesterday my Reiserfs on an LVM is crashed again. So i have 30 houers
> wasted my time to fix it. Currently i am mooving my Datas to all
> Computers with available free Space in my Network. I thing ist necessary
> to format the Volumes new. That make's my realy sick. EXT3 is good but
> it needs often an Filesystemcheck and by more then 1 TB it's wasting
> Time again. So I have readed something about btrfs. I don't need to use
> LVM because btrfs should have LVM functionality inside. OK i have readed
> that btrfs hasn't an productive Status on this Time but it is realy
> intersting. So i have questions about Dataintegrity. What happens if my
> System gets an Kernelpanic or an other Crash/Mistake and i have to hard
> reset my System? How is the status of Recoverytools

RIght now the btrfs disk format isn't finalized.  So, you will need to 
reformat your volumes a few more times to track btrfs development.

I wouldn't suggest using it yet for production.  XFS and ext3 are going to be 
your two best choices today.

-chris
