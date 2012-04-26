From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Optionally enforced time-based ACLs for BTRFS
Date: Thu, 26 Apr 2012 16:04:23 -0400
Message-ID: <20120426200423.GR22794@shiny>
References: <DE6EA944EF16AF4CA4C0D1856C83808006C7F05E96@ex7>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: David Bruzos <David.Bruzos@jaxport.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <DE6EA944EF16AF4CA4C0D1856C83808006C7F05E96@ex7>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 26, 2012 at 03:30:39PM -0400, David Bruzos wrote:

> Hi BTRFS folks: In my organization, many use cases exist for a
> time-based honoring  field for FS ACLs.  I've done some brief research
> regarding this topic, but I was unable to find any reference to such a
> thing in any file system.  I understand that a feature like time-based
> honoring for ACLs may arguably be something that should exist in
> higher layers (E.G. some document management system), but on the other
> hand, I see no real reason that an extra ACL field that would allow
> for time-based granting/removing of permissions to some user would be
> a problem.

One of the interesting thing about linux acls is the filesystems don't
really implement acls.  We implement xattrs, and the higher layers stuff
acls into them.  In a few key spots we tell the higher layers how to do
that, and we also call back into the higher layers for permission
checks.

This is a long way of saying the changes would have to happen in the
generic acl code.  This is a good thing, it will get much more review
that way.

I'd suggest posting this to linux-fsdevel.

-chris
