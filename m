From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH 01/21] Btrfs: get rid of *_alloc_profile fields
Date: Tue, 27 Sep 2011 14:51:17 +0200
Message-ID: <20110927125117.GZ22205@twin.jikos.cz>
References: <1314129722-31601-1-git-send-email-idryomov@gmail.com> <1314129722-31601-2-git-send-email-idryomov@gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	Hugo Mills <hugo@carfax.org.uk>
To: Ilya Dryomov <idryomov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1314129722-31601-2-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 23, 2011 at 11:01:42PM +0300, Ilya Dryomov wrote:
> {data,metadata,system}_alloc_profile fields have been unused for a long
> time now.  Get rid of them.

a good cleanup which could be sent separately.
d/
