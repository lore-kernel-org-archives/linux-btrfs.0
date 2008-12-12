From: Chris Mason <chris.mason@oracle.com>
Subject: Re: PROBLEM: oops when running fsstress against compressed btrfs
 filesystem
Date: Fri, 12 Dec 2008 09:25:58 -0500
Message-ID: <1229091958.11620.3.camel@think.oraclecorp.com>
References: <493860B8.4040309@hp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Eric Whitney <eric.whitney@hp.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <493860B8.4040309@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2008-12-04 at 17:59 -0500, Eric Whitney wrote:
> Chris:
> 
> I'm consistently getting oopses when running fsstress against both 
> single and multiple device compressed btrfs filesystems using kernels 
> built from the current btrfs-unstable.
> 

Sorry it took so long to reply to this one, I wanted to get the new csum
code nailed down before I asked you to retest.  I've changed big parts
of the compressed IO submission path, and I'd like to see if this bug is
still a problem.

-chris


