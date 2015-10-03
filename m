Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-32.italiaonline.it ([212.48.25.160]:38291 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750947AbbJCRlg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 3 Oct 2015 13:41:36 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH 4/4] btrfs-progs: change -t option for subvolume list to
 print a simple space-separated table (making it machine-readable)
References: <1443804083-876-1-git-send-email-axel@tty0.ch>
 <1443804083-876-5-git-send-email-axel@tty0.ch> <560FA665.6000700@libero.it>
 <560FA944.3050606@digint.ch>
To: Axel Burri <axel@digint.ch>
From: Goffredo Baroncelli <kreijack@inwind.it>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <5610134D.9070807@inwind.it>
Date: Sat, 3 Oct 2015 19:41:33 +0200
MIME-Version: 1.0
In-Reply-To: <560FA944.3050606@digint.ch>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-10-03 12:09, Axel Burri wrote:
> 
> 
> On 2015-10-03 11:56, Goffredo Baroncelli wrote:
>> On 2015-10-02 18:41, axel@tty0.ch wrote:
>>> Old implementation used tabs "\t", and tried to work around problems
>>> by guessing amount of tabs needed (e.g. "\t\t" after top level", with
>>> buggy output as soon as empty uuids are printed). This will never work
>>> correctly, as tab width is a user-defined setting in the terminal.
>>
>>
>> Why not use string_table() and table_*() functions  ? 
> 
> string_table(), as well as all table functions by nature, needs to know
> the maximum size of all cells in a row before printing, and therefore
> buffers all the output before printing. It would eat up a lot of memory
> for large tables (it is not unusual to have 1000+ subvolumes in btrfs if
> you make heavy use of snapshotting). Furthermore, it would slow down
> things by not printing the output linewise.


Assuming 200bytes per row (== subvolume) x 1000 subvolumes = 200kB... I don't think that this could be a problem, nor in terms of memory used nor in terms of speed: if you have 1000+ subvolumes the most time consuming activity is traversing the filesystem looking at the snapshot...



> 
>>
>>>
>>> Keep it simple and don't reimplement the wheel, for nice tabular
>>> output we have the "column" command from util-linux:
>>>
>>>     btrfs subvolume list -t <path> | column -t
>>>
>>> Signed-off-by: Axel Burri <axel@tty0.ch>
>>> ---
>>>  btrfs-list.c | 40 ++++++++++++----------------------------
>>>  1 file changed, 12 insertions(+), 28 deletions(-)
>>>
>>> diff --git a/btrfs-list.c b/btrfs-list.c
>>> index f8396e7..c09257a 100644
>>> --- a/btrfs-list.c
>>> +++ b/btrfs-list.c
>>> @@ -45,12 +45,12 @@ struct root_lookup {
>>>  };
>>>  
>>>  static struct {
>>> -	char	*name;
>>> +	char	*name;  /* machine-readable column identifier: [a-z_]+ */
>>>  	char	*column_name;
>>>  	int	need_print;
>>>  } btrfs_list_columns[] = {
>>>  	{
>>> -		.name		= "ID",
>>> +		.name		= "id",
>>>  		.column_name	= "ID",
>>>  		.need_print	= 0,
>>>  	},
>>> @@ -70,7 +70,7 @@ static struct {
>>>  		.need_print	= 0,
>>>  	},
>>>  	{
>>> -		.name		= "top level",
>>> +		.name		= "top_level",
>>>  		.column_name	= "Top Level",
>>>  		.need_print	= 0,
>>>  	},
>>> @@ -1465,13 +1465,10 @@ static void print_single_volume_info_table(struct root_info *subv)
>>>  		if (!btrfs_list_columns[i].need_print)
>>>  			continue;
>>>  
>>> -		print_subvolume_column(subv, i);
>>> -
>>> -		if (i != BTRFS_LIST_PATH)
>>> -			printf("\t");
>>> +		if (i != 0)
>>> +			printf(" ");
>>>  
>>> -		if (i == BTRFS_LIST_TOP_LEVEL)
>>> -			printf("\t");
>>> +		print_subvolume_column(subv, i);
>>>  	}
>>>  	printf("\n");
>>>  }
>>> @@ -1496,30 +1493,17 @@ static void print_single_volume_info_default(struct root_info *subv)
>>>  static void print_all_volume_info_tab_head(void)
>>>  {
>>>  	int i;
>>> -	int len;
>>> -	char barrier[20];
>>> -
>>> -	for (i = 0; i < BTRFS_LIST_ALL; i++) {
>>> -		if (btrfs_list_columns[i].need_print)
>>> -			printf("%s\t", btrfs_list_columns[i].name);
>>> -
>>> -		if (i == BTRFS_LIST_ALL-1)
>>> -			printf("\n");
>>> -	}
>>>  
>>>  	for (i = 0; i < BTRFS_LIST_ALL; i++) {
>>> -		memset(barrier, 0, sizeof(barrier));
>>> +		if (!btrfs_list_columns[i].need_print)
>>> +			continue;
>>>  
>>> -		if (btrfs_list_columns[i].need_print) {
>>> -			len = strlen(btrfs_list_columns[i].name);
>>> -			while (len--)
>>> -				strcat(barrier, "-");
>>> +		if (i != 0)
>>> +			printf(" ");
>>>  
>>> -			printf("%s\t", barrier);
>>> -		}
>>> -		if (i == BTRFS_LIST_ALL-1)
>>> -			printf("\n");
>>> +		printf(btrfs_list_columns[i].name);
>>>  	}
>>> +	printf("\n");
>>>  }
>>>  
>>>  static void print_all_volume_info(struct root_lookup *sorted_tree,
>>>
>>
>>
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
