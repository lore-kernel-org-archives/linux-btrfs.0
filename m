From: Thomas Glanzmann <thomas@glanzmann.de>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Tue, 28 Apr 2009 19:34:01 +0200
Message-ID: <20090428173401.GC7217@cip.informatik.uni-erlangen.de>
References: <20090427033331.GC17677@cip.informatik.uni-erlangen.de> <1240839448.26451.13.camel@think.oraclecorp.com> <20090428155900.GA1722@cip.informatik.uni-erlangen.de> <49F728F6.6030307@wpkg.org> <49F73CEF.4030105@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tomasz Chmielewski <mangoo@wpkg.org>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
To: Edward Shishkin <edward.shishkin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49F73CEF.4030105@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

> I wouldn't rely on crc32: it is not a strong hash,
> Such deduplication can lead to various problems,
> including security ones.

sure thing, did you think of replacing crc32 with sha1 or md5, is this
even possible (is there enough space reserved so that the change can be
done without changing the filesystem layout) at the moment with btrfs?

        Thomas
