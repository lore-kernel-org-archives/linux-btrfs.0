From: Mike <ipso@snappymail.ca>
Subject: Re: Honest timeline for btrfsck
Date: Fri, 07 Oct 2011 08:39:36 -0700
Message-ID: <4E8F1D38.7030202@snappymail.ca>
References: <CAGh96GFhVEfXt=xcb-uGEBA3Ss2fc8BwOpJ2g8tXbm+VimdH3Q@mail.gmail.com> <4E5FE9FC.9040705@cchtml.com> <20110901203442.GA17928@carfax.org.uk> <201109101209.40759.Martin@lichtvoll.de> <CA+JuuGrvCTP=o8umQHQV968tMSfJzxAFOfnGO2RKV3RU4_Vshw@mail.gmail.com> <20111005061628.GA3702@shiny.elevennetworks.com> <CA+JuuGoG1rhQ9S+vfa17BKdekp-A1UeNHqeYEwxfg=Co3Ts_pQ@mail.gmail.com> <20111005145843.GA4770@shiny.elevennetworks.com> <CA+JuuGq8ODcFDh_KEy3YL_pVJ1=zKDX1SD_9Ou_tHpR4XGhwgQ@mail.gmail.com> <20111007025050.GA4767@shiny.Netlink.Wireless>
Reply-To: ipso@snappymail.ca
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Chris Mason <chris.mason@oracle.com>,
	Jeff Putney <jeffrey.putney@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111007025050.GA4767@shiny.Netlink.Wireless>
List-ID: <linux-btrfs.vger.kernel.org>

On 11-10-06 07:50 PM, Chris Mason wrote:
> That's how software goes sometimes, and I'll take the criticism because
> it hasn't gone as well as it should have.  But, I can't stress enough how
> much I appreciate everyone's contributions and interest in btrfs.

With all due respect Chris, your actions and your words seem to 
contradict each other. It would appear that people are wanting to help 
contribute, but without showing them the code, you're preventing any 
contributions from happening. As you know, contributing is more than 
just code, just as important is proper testing, especially with a fsck tool.

I also don't think you are giving people enough credit. e2fsck will 
cause corruption pretty much everytime its run on a mounted file system, 
but a nice big nasty warning message seems to handle that quite well and 
anyone who ignores it, well thats their own fault, not the developers:

e2fsck 1.41.14 (22-Dec-2010)
/dev/sdb1 is mounted.

WARNING!!!  The filesystem is mounted.   If you continue you ***WILL***
cause ***SEVERE*** filesystem damage.

Do you really want to continue (y/n)? cancelled!

You could easily place the same warning in btrfs fsck even for normal 
use and recommend/require that it be run on a loopback image rather than 
the actual data itself or something. Heck, even have it run in "make no 
changes" mode by default and require recompiling to enable "fix my 
filesystem" mode.

In fact, when its first released that would probably be a good idea to 
do this anyways. The reality is, it doesn't matter how long you work on 
the fsck tool, its pretty much guaranteed to be a few bugs that corrupt 
some peoples data even more than it was before, thats the price you pay 
for being on the bleeding edge.

Don't get me wrong, I definitely appreciate all your work, I just wish I 
could appreciate it even more with a fsck tool. ;)

-- Mike
