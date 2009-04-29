From: Thomas Glanzmann <thomas@glanzmann.de>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Wed, 29 Apr 2009 14:03:00 +0200
Message-ID: <20090429120300.GG22917@cip.informatik.uni-erlangen.de>
References: <20090427033331.GC17677@cip.informatik.uni-erlangen.de> <200904281945.10274.hjclaes@web.de> <20090428201619.GK7217@cip.informatik.uni-erlangen.de> <200904282236.07428.hjclaes@web.de> <20090428205242.GA13112@cip.informatik.uni-erlangen.de> <1240952295.15136.73.camel@think.oraclecorp.com> <20090428211255.GB13112@cip.informatik.uni-erlangen.de> <1240953977.15136.76.camel@think.oraclecorp.com> <20090428221455.GA27794@cip.informatik.uni-erlangen.de> <1240960687.15136.88.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Heinz-Josef Claes <hjclaes@web.de>,
	Edward Shishkin <edward.shishkin@gmail.com>,
	Tomasz Chmielewski <mangoo@wpkg.org>,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1240960687.15136.88.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hello Chris,

> You can start with the code documentation section on
> http://btrfs.wiki.kernel.org

I read through this and at the moment one questions come in my mind:

http://btrfs.wiki.kernel.org/images-btrfs/7/72/Chunks-overview.png

Looking at this picture, when I'm going to implement the dedup code, do I also
have to take care to spread the blocks over the different devices or is
there already infrastructure in place that automates that process?

> I'll write up my ideas on how userspace controlled dedup should work.

I'm looking forward to this and will use it as an implementation road
map.

        Thomas
