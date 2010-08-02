From: Roberto Ragusa <mail@robertoragusa.it>
Subject: Re: Number of hard links limit
Date: Mon, 02 Aug 2010 22:43:08 +0200
Message-ID: <4C572DDC.5050108@robertoragusa.it>
References: <20100802114046.GA29926@lh.kyla.fi>	<20100802130556.GF30325@jeru.org>	<4ad406cb8ee6c52747b67b4c79a6d7dd@smtp.arbitraryconstant.com> <20100802215647.7466601d@simplux>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100802215647.7466601d@simplux>
List-ID: <linux-btrfs.vger.kernel.org>

Michael Niederle wrote:
>> Also, I believe it's not strictly 256 links, it's dependent on the length
>> of the names.
>>
>> I recall Chris posting something about being able to fix this without a
>> format change, though it wasn't a priority yet.
> 
> As to my knowledge the limit is 64KB for all names of a single file and due to
> Chris it will take a format change to fix this.
> 
> I ran into the limit some month ago while installing some Gentoo packages.

That means it would not work for my backup server.
At 4 backups per day, failure for filenames with 45 characters after just
one year.

-- 
   Roberto Ragusa    mail at robertoragusa.it
