From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: Observed unexpected behavior of BTRFS in d_instantiate
Date: Thu, 28 Apr 2011 13:13:49 -0400
Message-ID: <1304010829.16286.10.camel@moss-pluto>
References: <4DB78A4A.1080507@schaufler-ca.com>
	 <1303997441.16286.2.camel@moss-pluto>  <4DB99DF5.8040406@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: LSM <linux-security-module@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
To: Casey Schaufler <casey@schaufler-ca.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DB99DF5.8040406@schaufler-ca.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2011-04-28 at 10:03 -0700, Casey Schaufler wrote:
> On 4/28/2011 6:30 AM, Stephen Smalley wrote:
> > On Tue, 2011-04-26 at 20:15 -0700, Casey Schaufler wrote:
> >> I have been tracking down an problem that we've been seeing
> >> with Smack on top of btrfs and have narrowed it down to a check
> >> in smack_d_instantiate() that checks to see if the underlying
> >> filesystem supports extended attributes by looking at
> >>
> >>     inode->i_op->getxattr
> >>
> >> If the filesystem has no entry for getxattr it is assumed that
> >> it does not support extended attributes. The Smack code clearly
> >> finds this value to be NULL for btrfs and uses a fallback value.
> >> Clearly something is amiss, as other code paths clearly find the
> >> i_op->getxattr function and use it to effect. The btrfs code
> >> quite obviously includes getxattr functions.
> >>
> >> So, what is btrfs up to such that the inode ops does not include
> >> getxattr when security_d_instantiate is called? I am led to
> >> understand that SELinux has worked around this, but looking at
> >> the SELinux code I expect that there is a problem there as well.
> >>
> >> Thank you.
> > kernel version(s)?
> 
> 2.6.37
> 2.6.39rc4
> 
> > reproducer?
> 
> The MeeGo team saw the behavior first. I have been instrumenting
> the Smack code to track down what is happening. I am in the process
> of developing a Smack workaround for the btrfs behavior.

If this is for newly created files, then we initialize the in-core
security label for the inode as part of the inode_init_security hook in
SELinux and thus don't even try to call ->getxattr at d_instantiate
time.  Not sure though why it wouldn't already be set.

-- 
Stephen Smalley
National Security Agency

