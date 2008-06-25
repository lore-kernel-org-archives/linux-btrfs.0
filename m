From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] add proper ACL support to btrfs.  Now with acl caching!
Date: Wed, 25 Jun 2008 16:26:02 -0400
Message-ID: <1214425562.10187.698.camel@think.oraclecorp.com>
References: <20080618175205.GF20021@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080618175205.GF20021@unused.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-06-18 at 13:52 -0400, Josef Bacik wrote:
> Hello,
> 
> This is an updated version of the patch I sent earlier today.  This adds acl
> cacheing to make things a little bit faster.  I did all my acl tests with this
> and dbench -x 10 and here are my numbers
> 

Fantastic.  I think you can update this to the locking code I just
pushed out by just removing uses of fs_mutex.  If you want to give that
a shot, I'll try to get it integrated before running off on vacation.

-chris


