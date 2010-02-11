From: rk <rkasl@computer.org>
Subject: Re: [RFC] Move all btrfs command to only one command: btrfs.c
Date: Thu, 11 Feb 2010 16:20:07 -0500
Message-ID: <4B747487.8000401@computer.org>
References: <201001212029.26681.kreijack@libero.it> <201001241835.40562.kreijack@libero.it> <20100211163342.GA11297@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, Michael Niederle <mniederle@gmx.at>,
	Xavier Nicollet <nicollet@jeru.org>,
	Adrian von Bidder <avbidder@fortytwo.ch>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100211163342.GA11297@think>
List-ID: <linux-btrfs.vger.kernel.org>

.. it would be good to have some "mechanism" that will "prevent" people
mixing -d with -D

Chris Mason wrote:
> On Sun, Jan 24, 2010 at 06:35:33PM +0100, Goffredo Baroncelli wrote:
>   
>> Hi all,
>>
>> this is a follow-up of the previous email. I rewrite the btrfs command in C. 
>> Now the following actions are implemented:
>>
>> snapshot (-s) -> create a snapshot
>> delete   (-D) -> delete a subvolume or a snapshot
>> create   (-S) -> create a subvolume
>> defrag   (-d) -> defrag a tree or a file
>> fssync   (-c) -> sync a filesystem
>> scan     (-a) -> scan devices searching a btrfs filesystem
>> show     (-l) -> list the btrfs fs and its  volumes
>> balance  (-b) -> balance the chunk across the volumes
>> add-dev  (-A) -> add a volume to a filesystem
>> rem-dev  (-R) -> remove a volume to a filesystem
>>
>> I cared that btrfs returns appropriate error code. And I check that a correct 
>> parameters number is passed. Finally, where appropriate if a subvolume is 
>> required (for example in case of snapshot and or delete) is checked that the 
>> passed path is a subvolume. This should limits the complain like:
>> - I snapshot a sub directory, but I got a snapshot of the entire tree.
>>
>> I renamed remove (a volume) in rem-dev in order to avoid confusion with delete 
>> (a subvolume).
>>     
>
> Sorry for the late reply, but I really like this mode and will work on
> integrating it.  rem-dev should be rm-dev or remove-dev
>
> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

