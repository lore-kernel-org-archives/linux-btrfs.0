From: Jacek Luczak <difrost.kernel@gmail.com>
Subject: Re: getdents - ext4 vs btrfs performance
Date: Fri, 2 Mar 2012 15:16:12 +0100
Message-ID: <CADDYkjT8apYQpdZqr1gZKiHbm9xfTaLr=8GEJF0VKF9neHwgOg@mail.gmail.com>
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com>
	<E15A491F-62E2-4518-939F-07B3AB4C3E65@mit.edu>
	<20120301143859.GX5054@shiny>
	<CADDYkjQ8jgWUo7=eAeMjve0iRmVZMcrjjbqnvPq0SchE5W9Fqg@mail.gmail.com>
	<20120302140038.GD5054@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Jacek Luczak <difrost.kernel@gmail.com>,
	Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <20120302140038.GD5054@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

2012/3/2 Chris Mason <chris.mason@oracle.com>:
> On Fri, Mar 02, 2012 at 11:05:56AM +0100, Jacek Luczak wrote:
>>
>> I've took both on tests. The subject is acp and spd_readdir used wit=
h
>> tar, all on ext4:
>> 1) acp: http://91.234.146.107/~difrost/seekwatcher/acp_ext4.png
>> 2) spd_readdir: http://91.234.146.107/~difrost/seekwatcher/tar_ext4_=
readir.png
>> 3) both: http://91.234.146.107/~difrost/seekwatcher/acp_vs_spd_ext4.=
png
>>
>> The acp looks much better than spd_readdir but directory copy with
>> spd_readdir decreased to 52m 39sec (30 min less).
>
> Do you have stats on how big these files are, and how fragmented they
> are? =A0For acp and spd to give us this, I think something has gone w=
rong
> at writeback time (creating individual fragmented files).

How big? Which files?

-Jacek
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
