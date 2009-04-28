From: Thomas Glanzmann <thomas@glanzmann.de>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Tue, 28 Apr 2009 19:32:51 +0200
Message-ID: <20090428173251.GB7217@cip.informatik.uni-erlangen.de>
References: <20090427033331.GC17677@cip.informatik.uni-erlangen.de> <1240839448.26451.13.camel@think.oraclecorp.com> <20090428155900.GA1722@cip.informatik.uni-erlangen.de> <49F728F6.6030307@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49F728F6.6030307@wpkg.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello Tomasz,

> Did you just compare checksums, or did you also compare the data "bit
> after bit" if the checksums matched?

no, I just used the md5 checksum. And even if I have a hash escalation
which is highly unlikely it still gives a good house number.

        Thomas
