From: Bron Gondwana <brong@fastmail.fm>
Subject: Re: More performance results
Date: Wed, 4 Feb 2009 13:57:29 +1100
Message-ID: <20090204025729.GB2248@brong.net>
References: <49871813.8090309@austin.ibm.com> <f24d23310902030532w6cad0b6v209951bb24fba388@mail.gmail.com> <1233673296.7246.4.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: debian developer <debiandev@gmail.com>,
	Steven Pratt <slpratt@austin.ibm.com>,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1233673296.7246.4.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 03, 2009 at 10:01:36AM -0500, Chris Mason wrote:
> [...] In my testing
> here, the big difference between ext4 and btrfs isn't writing to files,
> it is actually the unlinks.  If I take them out of the run, btrfs is
> very close to ext4 times.

Oh man, what is it with unlinks.  Nobody does them very fast.

We use "delayed delete" with Cyrus so that the majority of unlinks
get saved for the weekend, and even then run them serially because
the IO hit is so high.  We do more IO during the cyr_expire run than
even the peak of U.S. day.

A "multi-unlink" API would be seriously nice, where you could say "I
want all these files to disappear, so don't bother trying to keep making
the directory entries consistent in-between-times".

Especially, 'rm -rf' performance really sucks with single unlinks -
you're re-creating all this directory data that's just going to be
discarded in a second anyway.

Bron ( wondering how much is "it's a hard problem" and how much is
       "nobody bothers to optimise it" )
