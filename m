From: Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH 05/21] Btrfs: add basic restriper infrastructure
Date: Tue, 01 Nov 2011 12:08:48 +0100
Message-ID: <4EAFD340.5090404@gmx.net>
References: <1314129722-31601-1-git-send-email-idryomov@gmail.com> <1314129722-31601-6-git-send-email-idryomov@gmail.com> <4EAFC526.4040701@gmx.net> <20111101110734.GE12759@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Ilya Dryomov <idryomov@gmail.com>, linux-btrfs@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>,
	Hugo Mills <hugo@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111101110734.GE12759@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On 01.11.2011 12:07, David Sterba wrote:
> On Tue, Nov 01, 2011 at 11:08:38AM +0100, Arne Jansen wrote:
>>> +/*
>>> + * Should be called with restripe_mutex held
>>> + */
>>> +int btrfs_restripe(struct restripe_control *rctl)
>>> +{
> ...
>>> +	if (rctl->data.target & BTRFS_BLOCK_GROUP_DUP) {
>>> +		printk(KERN_ERR "btrfs: dup for data is not allowed\n");
>>> +		ret = -EINVAL;
>>> +		goto out;
>>> +	}
>>
>> It would be good to get these error messages somehow to the user,
>> or at least give the user a hint to look in dmesg.
> 
> the restriper command ends with EINVAL which is in most cases returned
> as a result of the ioctl and progs counterpart will
> 
> 1117                         fprintf(stderr, "ERROR: error during restriping '%s' "
> 1118                                 "- %s\n", path, strerror(e));
> 1119                         return 19;
> 
> the hint should go there imho.

Though it would still be much nicer to get a proper error message to the
user directly.

> 
> 
> david
