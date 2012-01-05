From: Daniel Pocock <daniel@pocock.com.au>
Subject: Re: (renamed thread) btrfs metrics
Date: Thu, 05 Jan 2012 11:09:07 +0100
Message-ID: <4F0576C3.90502@pocock.com.au>
References: <4F01BF5D.2070801@pocock.com.au>	<CAE5mzviX5kJ70nG3bLPwE7E3ZjmdQvsKNUbs6XXqVhs+MEeSXw@mail.gmail.com>	<4F01C6DC.3040609@pocock.com.au>	<20120102151422.GA27122@carfax.org.uk>	<4F01DA85.4050107@pocock.com.au>	<20120102163944.GB27122@carfax.org.uk>	<4F043C75.1080204@pocock.com.au> <CABsxX9+J9XvBzV8OEHfKJSaYtB8RziysW4JDtYW75Qje7tt4vQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Hugo Mills <hugo@carfax.org.uk>, cwillu <cwillu@cwillu.com>,
	linux-btrfs@vger.kernel.org
To: "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CABsxX9+J9XvBzV8OEHfKJSaYtB8RziysW4JDtYW75Qje7tt4vQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


> 
> From there on, one could potentially create a matrix: (proportional
> font art, apologies):
> 
>           | subvol1  | subvol2  | subvol3  |
> ----------+----------+----------+----------+
>  subvol1  |   200M   |     20M  |     50M  |
> ----------+----------+----------+----------+
>  subvol2  |    20M   |    350M  |     22M  |
> ----------+----------+----------+----------+
>  subvol3  |    50M   |     22M  |    634M  |
> ----------+----------+----------+----------+
> 
> The diagonal obviously shows the "unique" blocks, subvol2 and subvol1
> share 20M data, etc. Missing from this plot would be "how much is
> shared between subvol1, subvol2, and subvol3" together, but it's a
> start and not something that hard to understand. One might add a
> column for "total size" of each subvol, which may obviously not be an
> addition of the rest of the columns in this diagram.
> 
> Anyway, something like this would be high on my list of `df` numbers
> I'd like to see - since I think they are useful numbers.
> 

This is an interesting way to look at it

Ganglia typically records time series data, it is quite conceivable to
create a metric for every permutation in each and store that in rrdtool

The challenge would then be in reporting on the data: the rrdtool graphs
use time as an X-axis, and then it can display multiple Y values

However, now that I've started thinking about the type of data generated
from btrfs, I was wondering if some kind of rr3dtool is needed - a 3D
graphing solution - or potentially making graphs that do not include
time on any axis?

Has anyone seen anything similar for administering ZFS, for example?

