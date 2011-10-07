From: Jeff Mahoney <jeffm@suse.de>
Subject: Re: Honest timeline for btrfsck
Date: Fri, 07 Oct 2011 00:45:34 -0400
Message-ID: <4E8E83EE.1090107@suse.de>
References: <CAGh96GFhVEfXt=xcb-uGEBA3Ss2fc8BwOpJ2g8tXbm+VimdH3Q@mail.gmail.com> <4E5FE9FC.9040705@cchtml.com> <20110901203442.GA17928@carfax.org.uk> <201109101209.40759.Martin@lichtvoll.de> <CA+JuuGrvCTP=o8umQHQV968tMSfJzxAFOfnGO2RKV3RU4_Vshw@mail.gmail.com> <20111005061628.GA3702@shiny.elevennetworks.com> <CA+JuuGoG1rhQ9S+vfa17BKdekp-A1UeNHqeYEwxfg=Co3Ts_pQ@mail.gmail.com> <20111005145843.GA4770@shiny.elevennetworks.com> <CA+JuuGq8ODcFDh_KEy3YL_pVJ1=zKDX1SD_9Ou_tHpR4XGhwgQ@mail.gmail.com> <20111007025050.GA4767@shiny.Netlink.Wireless>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Jeff Putney <jeffrey.putney@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111007025050.GA4767@shiny.Netlink.Wireless>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 10/06/2011 10:50 PM, Chris Mason wrote:
> On Thu, Oct 06, 2011 at 10:31:41AM -0500, Jeff Putney wrote:
>>> No, in this case it means we're confident it will get rolled
>>> out.
>> 
>> On Aug 18th confidence was high enough to declare a possible
>> release that very day.  This confidence turned into 7 weeks of
>> silence followed by another 2 week estimate.
>> 
>> These confident declarations are why things like mniederle's 
>> btrfs_rescue are considered 'interim' and not worth building on.
>> Had this confidence of imminent release not been the prevalent
>> message for the last year, others would have stepped in to fill
>> the void.
>> 
>>> I've given a number of hard dates recently and I'd prefer to
>>> show up with the code instead.  I don't think it makes sense to
>>> put a partial implementation out there, we'll just have a bunch
>>> of people reporting problems that I know exist.
>>> 
>>> -chris
>>> 
>> 
>> This strategy of 'Lone Wolfing it' has delayed the release by a
>> year. Either you are flying solo because you think that you can
>> make more meaningful progress without the involvement of the
>> btrfs community, or you are willing to forfeit the contributions
>> of the community in order to not have to listen to any
>> complaints.
>> 
>> The other problem of this flying solo plan, is that you are
>> making the assumption that the problems you know about are more
>> significant than the problems you are unaware of and could be
>> flushed out with more eyes on the code.  The longer you delay the
>> release of the source, the longer it will be until confidence can
>> be generated that major issues have been resolved.
>> 
>> http://en.wikipedia.org/wiki/Release_early,_release_often
> 
> [ Thanks for everyone's comments! ]
> 
> Keep in mind that btrfs was released and ran for a long time while 
> intentionally crashing when we ran out of space.   This was a
> really important part of our development because we attracted a
> huge number of contributors, and some very brave users.
> 
> For fsck, even the stuff I have here does have a way to go before
> it is at the level of an e2fsck or xfs_repair.  But I do want to
> make sure that I'm surprised by any bugs before I send it out, and
> that's just not the case today.  The release has been delayed
> because I've alternated between a few different ways of repairing,
> and because I got distracted by some important features in the
> kernel.

Yes. The single biggest rule of file system recovery tools is that you
never leave the file system more broken than when you found it. Beta
testing fsck, when the author him/herself isn't comfortable releasing
the code, is insane when you have data you care about. If you
disagree, I'll hit the pause button until you learn some very hard
lessons.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk6Og+4ACgkQLPWxlyuTD7KcywCeNmC9N5pwuHaLu1++YhoSQYWC
+Y0An0wgtv3dxsH6ZZCdPy2JihJWOe14
=g/pv
-----END PGP SIGNATURE-----
