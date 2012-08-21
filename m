Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:36217 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab2HUPFO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Aug 2012 11:05:14 -0400
Message-ID: <5033A395.6030309@oracle.com>
Date: Tue, 21 Aug 2012 23:04:53 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: David Sterba <dave@jikos.cz>,
        =?ISO-8859-1?Q?Llu=EDs_Batlle_i_R?= =?ISO-8859-1?Q?ossell?=
	<viric@viric.name>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>, andrei.popa@i-neo.ro
Subject: Re: State of nocow file attribute
References: <20120815101229.GH25996@vicerveza.homeunix.net> <502DA230.6010202@oracle.com> <20120817145940.GI17430@twin.jikos.cz> <502E6386.700@oracle.com> <20120821143304.GK17430@twin.jikos.cz>
In-Reply-To: <20120821143304.GK17430@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/21/2012 10:33 PM, David Sterba wrote:
> On Fri, Aug 17, 2012 at 11:30:14PM +0800, Liu Bo wrote:
>> IMO the following is better, just make use of the original check.  If you agree with this,
>> I'll send it as a patch :)
> 
> I think it's cleaner to keep all flags that get inherited from the
> directory -> new file at one place, ie btrfs_inherit_iflags(), than
> having them scattered over the code.
> 
>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index 6e8f416..d4e58df 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -4721,8 +4721,10 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
>>  		if (btrfs_test_opt(root, NODATASUM))
>>  			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATASUM;
>>  		if (btrfs_test_opt(root, NODATACOW) ||
>> -		    (BTRFS_I(dir)->flags & BTRFS_INODE_NODATACOW))
>> +		    (BTRFS_I(dir)->flags & BTRFS_INODE_NODATACOW)) {
>>  			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW;
>> +			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATASUM;
>> +		}
>>  	}
> 
> And even better, this particular check of dir->flags should be removed
> entirely, because it duplicates the equivalent in
> btrfs_inherit_iflags().
> 

Fine, it's cleaner now.

thanks,
liubo

>>  
>>  	insert_inode_hash(inode);
> 
> 
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

