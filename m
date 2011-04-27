From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Observed unexpected behavior of BTRFS in d_instantiate
Date: Tue, 26 Apr 2011 20:15:22 -0700
Message-ID: <4DB78A4A.1080507@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Casey Schaufler <casey@schaufler-ca.com>
To: LSM <linux-security-module@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-security-module-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>



I have been tracking down an problem that we've been seeing
with Smack on top of btrfs and have narrowed it down to a check
in smack_d_instantiate() that checks to see if the underlying
filesystem supports extended attributes by looking at

    inode->i_op->getxattr

If the filesystem has no entry for getxattr it is assumed that
it does not support extended attributes. The Smack code clearly
finds this value to be NULL for btrfs and uses a fallback value.
Clearly something is amiss, as other code paths clearly find the
i_op->getxattr function and use it to effect. The btrfs code
quite obviously includes getxattr functions.

So, what is btrfs up to such that the inode ops does not include
getxattr when security_d_instantiate is called? I am led to
understand that SELinux has worked around this, but looking at
the SELinux code I expect that there is a problem there as well.

Thank you.

