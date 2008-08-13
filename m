From: jim owens <jowens@hp.com>
Subject: Re: New feature Idea
Date: Wed, 13 Aug 2008 14:54:22 -0400
Message-ID: <48A32DDE.8070203@hp.com>
References: <48A320A0.80609@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Morey Roof <moreyroof@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48A320A0.80609@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Morey Roof wrote:
> I have been thinking about a new feature to start work on that I am 
> interested in and I was hoping people could give me some feedback and 
> ideas of how to tackle it.  Anyways, I want to create a data 
> deduplication system that can work in two different modes.  One mode is 
> that when the system is idle or not beyond a set load point a background 
> process would scan the volume for duplicate blocks.  The other mode 
> would be used for systems that are nearline or backup systems that don't 
> really care about the performance and it would do the deduplication 
> during block allocation.
> 
> One of the ways I was thinking of to find the duplicate blocks would be 
> to use the checksums as a quick compare.  If the checksums match then do 
> a complete compare before adjusting the nodes on the files.  However, I 
> believe that I will need to create a tree based on the checksum values.
> 
> So any other ideas and thoughts about this?

Don't do it!!!

OK, I know Chris has described some block sharing.  But I hate it.

If I copy "resume" to "resume.save", it is because I want 2 copies
for safety.  I don't want the fs to reduce it to 1 copy.  And
reducing the duplicates is exactly opposite to Chris's paranoid
make-multiple-copies-by-default.

Now feel free to tell me I'm an idiot (other people do) :)

jim
