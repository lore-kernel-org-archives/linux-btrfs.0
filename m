From: Gustavo Sverzut Barbieri <barbieri@gmail.com>
Subject: Re: corrupted btrfs after suspend2ram uncorrectable with scrub
Date: Wed, 9 Nov 2011 12:29:26 -0200
Message-ID: <CANkykrAf9XwE1CDRDNHuN_yTkY0o4ruH+SGbkzrsOhUms4mAAQ@mail.gmail.com>
References: <CANkykrA7uxc51rFTbTXar8v_3vE2Gn9LKYrApOfvqWNf5B_adw@mail.gmail.com>
	<orzkgfwlom.fsf@livre.localdomain>
	<CANkykrBn0Ed6B25UzRkvs6cKebTvhpqOW79F1UEc_2uMumqCQA@mail.gmail.com>
	<CANkykrCfvFH_fg+5vJVkoWgcPuFp6euzVxZPTRDf=U+qrYUipA@mail.gmail.com>
	<20111108172043.GH4954@shiny>
	<CANkykrDtHRDe0ve53dkxeNcCeTuWY0i1-8m1SR6BN8Md7F4qGQ@mail.gmail.com>
	<20111109142739.GP4149@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Gustavo Sverzut Barbieri <barbieri@gmail.com>,
	Alexandre Oliva <oliva@lsd.ic.unicamp.br>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111109142739.GP4149@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 9, 2011 at 12:27 PM, Chris Mason <chris.mason@oracle.com> w=
rote:
> On Wed, Nov 09, 2011 at 12:19:58PM -0200, Gustavo Sverzut Barbieri wr=
ote:
>> On Tue, Nov 8, 2011 at 3:20 PM, Chris Mason <chris.mason@oracle.com>=
 wrote:
>> > On Tue, Nov 08, 2011 at 03:08:41PM -0200, Gustavo Sverzut Barbieri=
 wrote:
>> >> On Tue, Nov 1, 2011 at 9:20 PM, Gustavo Sverzut Barbieri
>> >> <barbieri@gmail.com> wrote:
>> >> > On Tue, Nov 1, 2011 at 7:57 PM, Alexandre Oliva <oliva@lsd.ic.u=
nicamp.br> wrote:
>> >> >> Hi, Gustavo,
>> >> >>
>> >> >> On Nov =A01, 2011, Gustavo Sverzut Barbieri <barbieri@gmail.co=
m> wrote:
>> >> >>
>> >> >>> =A0 btrfs csum failed ino 2957021 extent 85041815552 csum 667=
310679
>> >> >>> wanted 0 mirror 0
>> >> >>
>> >> >>> Is there any way to recover it? =A0:-S
>> >> >>
>> >> >> Did you try mounting without data checksums?
>> >> >
>> >> > Just tried to mount with -o nodatasum, no luck. Is that enough?
>> >>
>> >> Ideas? Should I give up and consider data lost? :-(
>> >
>> > We actually check the crcs even when mounted with nodatasum. =A0Ca=
n you
>> > give the restore tool a shot from my current btrfs-progs git repo?=
 =A0If
>> > it can read it we can find a way to get the files off.
>>
>> Hi Chris,
>>
>> Fortunately it worked and I've restored, it misses symbolic links an=
d
>> executable permissions (or I did a mistake somewhere, like mounting)
>> but overall it's all fine.
>
> Great to hear you've pulled the files. =A0Do you need the kernel patc=
h for
> symlinks etc?

Nah, they were a couple of links from svn/git repos to ~/bin and
similar, I restored them already.


>> The attached patch was helpful to let me ignore stuff like developme=
nt
>> files and caches. Speeds up the recovery :-)
>
> Very nice, thanks.

Hope you can apply it :-)


--=20
Gustavo Sverzut Barbieri
--------------------------------------
Mobile: +55 (19) 9225-2202
Contact: http://www.gustavobarbieri.com.br/contact
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
