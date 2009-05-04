From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Mon, 04 May 2009 16:39:35 +0200
Message-ID: <49FEFE27.5090804@wpkg.org>
References: <20090427033331.GC17677@cip.informatik.uni-erlangen.de> <1240839448.26451.13.camel@think.oraclecorp.com> <20090428155900.GA1722@cip.informatik.uni-erlangen.de> <49F728F6.6030307@wpkg.org> <20090428173251.GB7217@cip.informatik.uni-erlangen.de> <49F73FC9.3070607@partiallystapled.com> <49FEFBE6.40209@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Michael Tharp <gxti@partiallystapled.com>,
	Thomas Glanzmann <thomas@glanzmann.de>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49FEFBE6.40209@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Ric Wheeler schrieb:

> One thing in the above scheme that would be really interesting for all 
> possible hash functions is maintaining good stats on hash collisions, 
> effectiveness of the hash, etc. There has been a lot of press about MD5 
> hash collisions for example - it would be really neat to be able to 
> track real world data on those,

See here ("The hashing function"):

http://backuppc.sourceforge.net/faq/BackupPC.html#some_design_issues

It's not "real world data", but it gives some overview which applies here.


-- 
Tomasz Chmielewski
http://wpkg.org
