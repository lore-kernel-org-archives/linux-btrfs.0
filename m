From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: Observed unexpected behavior of BTRFS in d_instantiate
Date: Thu, 28 Apr 2011 10:52:45 -0700
Message-ID: <4DB9A96D.7040500@schaufler-ca.com>
References: <4DB78A4A.1080507@schaufler-ca.com> <1303997441.16286.2.camel@moss-pluto> <4DB99DF5.8040406@schaufler-ca.com> <1304010829.16286.10.camel@moss-pluto> <1304011439.16286.15.camel@moss-pluto> <1304011601-sup-997@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Stephen Smalley <sds@tycho.nsa.gov>,
	LSM <linux-security-module@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Casey Schaufler <casey@schaufler-ca.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1304011601-sup-997@think>
List-ID: <linux-btrfs.vger.kernel.org>

On 4/28/2011 10:27 AM, Chris Mason wrote:
> Excerpts from Stephen Smalley's message of 2011-04-28 13:23:59 -0400:
>> On Thu, 2011-04-28 at 13:13 -0400, Stephen Smalley wrote:
>>> On Thu, 2011-04-28 at 10:03 -0700, Casey Schaufler wrote:
>>>> On 4/28/2011 6:30 AM, Stephen Smalley wrote:
>>>>> On Tue, 2011-04-26 at 20:15 -0700, Casey Schaufler wrote:
>>>>>> I have been tracking down an problem that we've been seeing
>>>>>> with Smack on top of btrfs and have narrowed it down to a check
>>>>>> in smack_d_instantiate() that checks to see if the underlying
>>>>>> filesystem supports extended attributes by looking at
>>>>>>
>>>>>>     inode->i_op->getxattr
>>>>>>
>>>>>> If the filesystem has no entry for getxattr it is assumed that
>>>>>> it does not support extended attributes. The Smack code clearly
>>>>>> finds this value to be NULL for btrfs and uses a fallback value.
>>>>>> Clearly something is amiss, as other code paths clearly find the
>>>>>> i_op->getxattr function and use it to effect. The btrfs code
>>>>>> quite obviously includes getxattr functions.
>>>>>>
>>>>>> So, what is btrfs up to such that the inode ops does not include
>>>>>> getxattr when security_d_instantiate is called? I am led to
>>>>>> understand that SELinux has worked around this, but looking at
>>>>>> the SELinux code I expect that there is a problem there as well.
>>>>>>
>>>>>> Thank you.
>>>>> kernel version(s)?
>>>> 2.6.37
>>>> 2.6.39rc4
>>>>
>>>>> reproducer?
>>>> The MeeGo team saw the behavior first. I have been instrumenting
>>>> the Smack code to track down what is happening. I am in the process
>>>> of developing a Smack workaround for the btrfs behavior.
>>> If this is for newly created files, then we initialize the in-core
>>> security label for the inode as part of the inode_init_security hook in
>>> SELinux and thus don't even try to call ->getxattr at d_instantiate
>>> time.  Not sure though why it wouldn't already be set.
>> Actually, a quick look at the code makes it clear.  btrfs_create() and
>> friends call d_instantiate() before setting inode->i_op() for new
>> inodes.  In contrast, ext[234] set the i_op before calling
>> d_instantiate().
>>
>> In any event, you don't really need to go through the slow path of
>> calling ->getxattr for new inodes as you already know the label that is
>> being set.

I prefer having a single code path that performs this critical bit
of security functionality.

> There's no reason we can't set i_op sooner in btrfs, I'll patch this in.

Thank you very much. I will be happy to test the patch.

> -chris

