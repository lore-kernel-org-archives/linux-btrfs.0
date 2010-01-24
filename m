From: Piavlo <piavka@cs.bgu.ac.il>
Subject: Re: [RFC] Move all btrfs command to only one command: btrfs.c
Date: Sun, 24 Jan 2010 20:34:43 +0200
Message-ID: <4B5C92C3.2090400@cs.bgu.ac.il>
References: <201001212029.26681.kreijack@libero.it> <201001241835.40562.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Cc: linux-btrfs@vger.kernel.org
To: Goffredo Baroncelli <kreijack@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201001241835.40562.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

Goffredo Baroncelli wrote:
> Hi all,
>
> this is a follow-up of the previous email. I rewrite the btrfs command in C. 
> Now the following actions are implemented:
>
> snapshot (-s) -> create a snapshot
> delete   (-D) -> delete a subvolume or a snapshot
> create   (-S) -> create a subvolume
> defrag   (-d) -> defrag a tree or a file
> fssync   (-c) -> sync a filesystem
> scan     (-a) -> scan devices searching a btrfs filesystem
> show     (-l) -> list the btrfs fs and its  volumes
> balance  (-b) -> balance the chunk across the volumes
> add-dev  (-A) -> add a volume to a filesystem
> rem-dev  (-R) -> remove a volume to a filesystem
>
> I cared that btrfs returns appropriate error code. And I check that a correct 
> parameters number is passed. Finally, where appropriate if a subvolume is 
> required (for example in case of snapshot and or delete) is checked that the 
> passed path is a subvolume. This should limits the complain like:
> - I snapshot a sub directory, but I got a snapshot of the entire tree.
>
> I renamed remove (a volume) in rem-dev in order to avoid confusion with delete 
> (a subvolume).
>   
To avoid such confusion IMHO it's logically better to have two commands
instead one for handling actions at volume level
and other command at file system level  - something like btrfs & btrpool
- like in other well known file system :)

Alex
> You can find a git repository in 
>
> 	http://cassiopea.homelinux.net/git/?p=btrfs-command.git;a=summary
>
> select the branch "btrfs-command"
>
> TODO:
> * resizing implementation
> * btrfstune implementation
> * btrfslabel implementation (but it require patch to the kernel)
> * mkfs implementation
> * check of the label length
> * test suite finalisation
> * test, test, test
>
> Suggestions are welcome.
>
> BR
> G.Baroncelli
>   

