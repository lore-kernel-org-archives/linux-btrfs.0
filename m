From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Fri, 05 Jun 2009 17:35:54 +0200
Message-ID: <4A293B5A.3050308@wpkg.org>
References: <1240960687.15136.88.camel@think.oraclecorp.com> <20090429120300.GG22917@cip.informatik.uni-erlangen.de> <1241010875.20099.2.camel@think.oraclecorp.com> <20090429135804.GI22917@cip.informatik.uni-erlangen.de> <1241015512.20099.30.camel@think.oraclecorp.com> <20090429152614.GJ22917@cip.informatik.uni-erlangen.de> <1241019915.20099.35.camel@think.oraclecorp.com> <20090604084919.GB22607@cip.informatik.uni-erlangen.de> <20090604114357.GK13945@think> <4A290DA0.5090105@wpkg.org> <20090605125016.GA6942@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Chris Mason <chris.mason@oracle.com>,
	Tomasz Chmielewski <mangoo@wpkg.org>,
	Thomas Glanzmann <thomas@glanzmann.de>,
	Heinz-Josef Claes <hjclaes@web.de>,
	Edward Shishkin <edward.shishk
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090605125016.GA6942@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:

>> I wonder how well would deduplication work with defragmentation? One  
>> excludes the other to some extent.
> 
> Very much so ;)  Ideally we end up doing dedup in large extents, but it
> will definitely increase the overall fragmentation of the FS.

Defragmentation could lead to interesting problems if it's not aware of 
dedupliction.


I can imagine "freeing up space" (i.e., as seen by userspace) where 
duplicated blocks are found, but keeping track of duplicated blocks 
internally (and not allowing to overwrite any block which is duplicated).

Only when free space is really needed, "deduplicate" blocks which have 
more copies, and allow to overwrite them with data.

Perhaps complicated though.


-- 
Tomasz Chmielewski
