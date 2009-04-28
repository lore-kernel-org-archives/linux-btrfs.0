From: Thomas Glanzmann <thomas@glanzmann.de>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Tue, 28 Apr 2009 19:43:38 +0200
Message-ID: <20090428174338.GE7217@cip.informatik.uni-erlangen.de>
References: <20090427033331.GC17677@cip.informatik.uni-erlangen.de> <1240839448.26451.13.camel@think.oraclecorp.com> <20090428155900.GA1722@cip.informatik.uni-erlangen.de> <49F728F6.6030307@wpkg.org> <49F73CEF.4030105@gmail.com> <20090428173401.GC7217@cip.informatik.uni-erlangen.de> <1240940304.15136.27.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Edward Shishkin <edward.shishkin@gmail.com>,
	Tomasz Chmielewski <mangoo@wpkg.org>,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1240940304.15136.27.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

> It is possible, there's room in the metadata for about about 4k of
> checksum for each 4k of data.  The initial btrfs code used sha256, but
> the real limiting factor is the CPU time used.

I see. There a very efficient md5 algorithms out there, for example,
especially if the code is written in assembler.

        Thomas
