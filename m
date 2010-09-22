From: Anish Tondwalkar <2012atondwal@tjhsst.edu>
Subject: Re: Current state of hot data relocation functionality
Date: Wed, 22 Sep 2010 19:36:54 -0400
Message-ID: <AANLkTimRobrN=UQDm11ZttGOwc+yhi11LKpfCRxTpW-X@mail.gmail.com>
References: <AANLkTi=k-ya8X4JU+=XGeK594AYHhye7_=knO_5eRHJS@mail.gmail.com> <AANLkTi=E5HkSj4OD+vs=1-evuM5CjGJefhj9GJsgPQsX@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Bostjan Skufca <bostjan@a2o.si>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=E5HkSj4OD+vs=1-evuM5CjGJefhj9GJsgPQsX@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

You can patch btrfs for experimental hot relocation.
Ben Chociej posted this: http://article.gmane.org/gmane.linux.kernel/10=
22603
--
Anish Tondwalkar


On Wed, Sep 22, 2010 at 7:04 PM, Bostjan Skufca <bostjan@a2o.si> wrote:
> Anyone?
>
> On 18 September 2010 01:33, Bostjan Skufca <bostjan@a2o.si> wrote:
>> Hi all!
>>
>> I was looking into some custom fileserver options and noticed two
>> facts about ZFS - support for L2ARC (albeit not persistant across
>> reboots, which is a downer) and OpenSolaris being a dead meat. Then =
I
>> found out that some patches were already floating around linux
>> mailinglists, patches about hot data relocation, but unfortunately
>> nothing definitive. So I would like to ask here: what is the status =
of
>> hot data relocation functionality?
>>
>> I haven't had a chance to try out btrfs myself, but from what I see =
it
>> sure looks promising and seems like an option worth waiting on (I me=
an
>> this from fileserver with SSD cache point of view). So keep up the
>> good work, and thanks for an answer, if there will be one :)
>>
>> Take care,
>> b.
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
