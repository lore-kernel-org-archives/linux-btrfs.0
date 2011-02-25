From: Joao Luis <jecluis@gmail.com>
Subject: Fwd: Comparing snapshots?
Date: Fri, 25 Feb 2011 23:26:14 +0000
Message-ID: <AANLkTin0-OKXwaXXxgLgUwrgD4kvg9qg0koRRVrkoNrq@mail.gmail.com>
References: <20110225095916.GA7609@suse.de>
	<6D8C263D-FCFC-49EE-AC28-8D821C3340CA@gmail.com>
	<4D680C38.10903@libero.it>
	<4977C273-8274-4C10-A19A-B766E224A20C@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4977C273-8274-4C10-A19A-B766E224A20C@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

I had rich text enabled by default, and the ml bounced back the email.
Apparently, HTML equals spam and/or virus. :-)

Here goes the plain-text version.


---------- Forwarded message ----------
=46rom: Jo=E3o Eduardo Lu=EDs <jecluis@gmail.com>
Date: 2011/2/25
Subject: Re: Comparing snapshots?
To: kreijack@inwind.it
Cc: linux-btrfs@vger.kernel.org


> On Feb 25, 2011, at 8:08 PM, Goffredo Baroncelli wrote:
>> On 02/25/2011 08:32 PM, Jo=E3o Eduardo Lu=EDs wrote:
>>
>> Hello,
>>
>> Please note that my experience with btrfs is both recent and, above
>> all, very small. However, I've been wondering about the same issue
>> for a different purpose and your question intrigues me.
>>
>> However, and I may be off-base here, I think that wouldn't be trivia=
l
>> to achieve.
>>
>> Even if one would be able to differ the metadata changes between bot=
h
>> snapshots, the problem would still be present regarding finding the
>> changed data. It would be possible to check for changed extents, at
>> least by comparing extent checksums, but I don't think it would be
>> trivial to discover where (exactly) the extent was modified.
>
> Look at the find-new command. It returns also which part of the file =
is
> changed. I don't remember very well the details, but also the data is
> stored in a tree like the metadata. Using the same strategies of
> comparing the keys and revid leads to discover which part of the file=
 is
> changed, with minimum effort (no checksums comparing is needed).


You are right. I just took a peek at the code, and it seems the
generation id (which IIRC is the same as the id of the last modifying
transaction) is shared file system wise, instead of being snapshot or
subvolume specific.
I should have confirmed in the code before replying.

Cheers.
---
Jo=E3o Eduardo Lu=EDs
gpg key: 477C26E5 from pool.keyserver.eu
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
