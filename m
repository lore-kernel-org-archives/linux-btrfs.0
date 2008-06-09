From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: btrfs panic - BUG: soft lockup - CPU#0 stuck for 61s! [fs_mark:4573]
Date: Mon, 09 Jun 2008 09:51:50 -0400
Message-ID: <484D3576.3070304@redhat.com>
References: <4844336F.1010807@redhat.com>	<20080605143428.GA16999@think.oraclecorp.com>	<484825D4.2010402@redhat.com> <20080608223712.73692933@think.oraclecorp.com>
Reply-To: rwheeler@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080608223712.73692933@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Thu, 05 Jun 2008 13:43:48 -0400
> Ric Wheeler <rwheeler@redhat.com> wrote:
>
>   
>> Chris Mason wrote:
>>     
>>> On Mon, Jun 02, 2008 at 01:52:47PM -0400, Ric Wheeler wrote:
>>>   
>>>       
>>>> I can reliably get btrfs to panic by running my fs_mark code on a
>>>> newly created file system with lots of threads on an 8-way box. If
>>>> this is too aggressive, let me know ;-)
>>>>
>>>> Here is a summary of the panic:
>>>>     
>>>>         
>>> BTW, exactly how are you running fs_mark?  Mingming reminded me that
>>> strictly speaking this patch shouldn't be required, so there might
>>> be other related problems.
>>>
>>> -chris
>>>
>>>   
>>>       
>> It still crashes, Mingming is clearly correct ;-)
>>
>>     
>
> Grin, I never should have doubted her.
>
> So, the actual fix should be below.  It looks like the problem is that I've got
> a race in setting the pointer to a new transaction, which makes the
> data=ordered code take a spin lock that hasn't yet been setup.
>
> Before this patch my test box got into an infinite loop with fs_mark.  Now it
> seems to run to completion.
>
> -chris
>   

Thanks Chris - this patch works for me as well,

ric

> diff -r 0b4ab489ffe1 transaction.c
> --- a/transaction.c	Tue May 27 10:55:43 2008 -0400
> +++ b/transaction.c	Sun Jun 08 22:23:50 2008 -0400
> @@ -56,7 +56,6 @@ static noinline int join_transaction(str
>  		total_trans++;
>  		BUG_ON(!cur_trans);
>  		root->fs_info->generation++;
> -		root->fs_info->running_transaction = cur_trans;
>  		root->fs_info->last_alloc = 0;
>  		root->fs_info->last_data_alloc = 0;
>  		cur_trans->num_writers = 1;
> @@ -74,6 +73,9 @@ static noinline int join_transaction(str
>  		extent_io_tree_init(&cur_trans->dirty_pages,
>  				     root->fs_info->btree_inode->i_mapping,
>  				     GFP_NOFS);
> +		spin_lock(&root->fs_info->new_trans_lock);
> +		root->fs_info->running_transaction = cur_trans;
> +		spin_unlock(&root->fs_info->new_trans_lock);
>  	} else {
>  		cur_trans->num_writers++;
>  		cur_trans->num_joined++;
>   

