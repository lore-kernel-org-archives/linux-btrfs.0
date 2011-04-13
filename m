From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH v3] Re: btrfs does not work on usermode linux
Date: Wed, 13 Apr 2011 07:32:59 -0400
Message-ID: <1302694333-sup-4155@think>
References: <20110410133710.0ef34cb6@sf> <20110410184249.483d8d67@sf> <20110410230622.09e965ae@sf> <20110410232403.617c3b7f@sf> <20110410235846.135e801e@sf> <4DA32055.2030104@redhat.com> <20110411224452.4a5149da@sf> <4DA35B98.3010800@redhat.com> <20110413002333.3d78d4d1@sf>
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	cwillu <cwillu@cwillu.com>
To: Sergei Trofimovich <slyich@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20110413002333.3d78d4d1@sf>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Sergei Trofimovich's message of 2011-04-12 17:23:33 -0400:
> On Mon, 11 Apr 2011 15:50:48 -0400
> Josef Bacik <josef@redhat.com> wrote:
> 
> > On 04/11/2011 03:44 PM, Sergei Trofimovich wrote:
> > >> Fix data corruption caused by memcpy() usage on overlapping data.
> > >> I've observed it first when found out usermode linux crash on btrfs.
> 
> ...
> 
> > Fair enough, BUG_ON() it is.  Repost that version and you can add my
> > 
> > Reviewed-by: Josef Bacik <josef@redhat.com>
> 
> Thank you! Added and resent as:
> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg09357.html
> 

This is in the master branch now, please give it another test.  Thanks a
lot for bisecting down and patching!

-chris
