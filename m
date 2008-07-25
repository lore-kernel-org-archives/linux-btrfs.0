From: Chris Mason <chris.mason@oracle.com>
Subject: Re: New data=ordered code pushed out to btrfs-unstable
Date: Fri, 25 Jul 2008 13:15:09 +0000
Message-ID: <1216991709.7572.31.camel@think.oraclecorp.com>
References: <1216398992.6932.36.camel@think.oraclecorp.com>
	 <4880F87B.7020908@gmail.com>
	 <1216411969.6932.70.camel@think.oraclecorp.com>
	 <48811ABF.5010606@gmail.com>
	 <1216428331.6932.82.camel@think.oraclecorp.com>
	 <48832D42.6030204@redhat.com>
	 <1216560741.6932.83.camel@think.oraclecorp.com>
	 <488341CB.1010007@redhat.com>
	 <1216652915.6932.113.camel@think.oraclecorp.com>
	 <4884D578.7040901@redhat.com>
	 <1216665311.6932.116.camel@think.oraclecorp.com>
	 <4884E235.1010206@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: rwheeler@redhat.com, linux-btrfs <linux-btrfs@vger.kernel.org>
To: Ric Wheeler <ricwheeler@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4884E235.1010206@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2008-07-21 at 15:23 -0400, Ric Wheeler wrote:

> >>> [ lock timeouts and stalls ]
> >>>
> >>>
> >>> Ok, I've made a few changes that should lower overall contenion on the
> >>> allocation mutex.  I'm getting better performance on a 3 million file
> >>> run, please give it a shot.
> >>
> >> After an update, clean rebuild & reboot, the test is running along and 
> >> has hit about 10 million files. I still see some messages like:
> >>
> >> INFO: task pdflush:4051 blocked for more than 120 seconds.

The latest code in btrfs-unstable has everything I can safely do right
now :)  

Basically the stalls come from someone doing IO with the allocation
mutex held.  It is surprising that we should be stalling for such a long
time, it is probably a  mixture of elevator starvation and btrfs fun.

But, btrfs-unstable also has code to replace the page lock with a
per-tree block mutex, which will allow me to get rid of the big
allocation mutex over the long term.  I was able to break up most of the
long operations and have them drop/reacquire the allocation mutex to
prevent this starvation most of the time.

-chris


