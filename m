From: "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
Subject: Re: (renamed thread) btrfs metrics
Date: Wed, 4 Jan 2012 10:46:27 -0800
Message-ID: <CABsxX9+J9XvBzV8OEHfKJSaYtB8RziysW4JDtYW75Qje7tt4vQ@mail.gmail.com>
References: <4F01BF5D.2070801@pocock.com.au>
	<CAE5mzviX5kJ70nG3bLPwE7E3ZjmdQvsKNUbs6XXqVhs+MEeSXw@mail.gmail.com>
	<4F01C6DC.3040609@pocock.com.au>
	<20120102151422.GA27122@carfax.org.uk>
	<4F01DA85.4050107@pocock.com.au>
	<20120102163944.GB27122@carfax.org.uk>
	<4F043C75.1080204@pocock.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Hugo Mills <hugo@carfax.org.uk>, cwillu <cwillu@cwillu.com>,
	linux-btrfs@vger.kernel.org
To: Daniel Pocock <daniel@pocock.com.au>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F043C75.1080204@pocock.com.au>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 4, 2012 at 3:48 AM, Daniel Pocock <daniel@pocock.com.au> wr=
ote:
>
>>> I am looking at what metrics are needed to monitor btrfs in product=
ion.
>>> =A0I actually look after the ganglia-modules-linux package, which i=
ncludes
>>> some FS space metrics, but I figured that btrfs throws all that out=
 the
>>> window.
>>>
>>> Can you suggest metrics that would be meaningful, do I look in /pro=
c or
>>> with syscalls, is there any code I should look at for an example of=
 how
>>> to extract them with C? =A0Ideally, Ganglia runs without root privi=
leges
>>> too, so please let me know if btrfs will allow me to access them
>>
>> =A0 =A0It depends on what you want to know, really. If you want "how=
 close
>> am I to a full filesystem?", then the output of df will give you a
>> measure, even if it could be up to a factor of 2 out -- you can use =
it
>> for predictive planning, though, as it'll be near zero when the FS
>> runs out of space.
>
>
> Maybe if you look at it from the point of the sysadmin and think abou=
t
> what questions he might want to ask:
>
> a) how much space would I reclaim if I deleted snapshot X?
>
> b) how much space would I reclaim if I deleted all snapshots?
>
> c) how much space would I need if I start making 4 snapshots a day an=
d
> keeping them for 48 hours?

chiming in on the discussion - what I'd like to personally see:

=46irst, probably easiest: Display per subvol the space used that is
"unique" (not used by other subvolumes), and shared (the opposite -
all blocks that appear in other subvolumes as well).

=46rom there on, one could potentially create a matrix: (proportional
font art, apologies):

          | subvol1  | subvol2  | subvol3  |
----------+----------+----------+----------+
 subvol1  |   200M   |     20M  |     50M  |
----------+----------+----------+----------+
 subvol2  |    20M   |    350M  |     22M  |
----------+----------+----------+----------+
 subvol3  |    50M   |     22M  |    634M  |
----------+----------+----------+----------+

The diagonal obviously shows the "unique" blocks, subvol2 and subvol1
share 20M data, etc. Missing from this plot would be "how much is
shared between subvol1, subvol2, and subvol3" together, but it's a
start and not something that hard to understand. One might add a
column for "total size" of each subvol, which may obviously not be an
addition of the rest of the columns in this diagram.

Anyway, something like this would be high on my list of `df` numbers
I'd like to see - since I think they are useful numbers.

Cheers,

Auke
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
