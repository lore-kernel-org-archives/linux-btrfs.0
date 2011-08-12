From: Dan Merillat <dan.merillat@gmail.com>
Subject: Re: [RFC, crash][PATCH] btrfs: allow cross-subvolume file clone
Date: Thu, 11 Aug 2011 21:27:22 -0400
Message-ID: <CAHZzDrDOo3-Jspt+PtPQpg7uyUeQHbtbZ0QKGsujvHBYKVa-KQ@mail.gmail.com>
References: <1312394862-28143-1-git-send-email-dsterba@suse.cz>
	<4E39F39E.9000002@cn.fujitsu.com>
	<20110809175012.GB20461@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: dave@jikos.cz, Miao Xie <miaox@cn.fujitsu.com>,
	David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
	chris.mason@oracle.com, josef@redhat.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110809175012.GB20461@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 9, 2011 at 1:50 PM, David Sterba <dave@jikos.cz> wrote:
> On Thu, Aug 04, 2011 at 09:19:26AM +0800, Miao Xie wrote:
>> > the patch has been applied on top of current linus which contains patches from
>> > both pull requests (ed8f37370d83).
>>
>> I think it is because the caller didn't reserve enough space.Could you try to
>> apply the following patch? It might fix this bug.
>>
>> [PATCH v2] Btrfs: reserve enough space for file clone
>> http://marc.info/?l=linux-btrfs&m=131192686626576&w=2
>
> Thanks! Yes, it does not crash anymore. Trees reflinked succesfully,
> md5sums verified.

This isn't a cross-subvolume problem, I hit the same bug trying to
reflink a pile of files within the same subvolume.   I applied the
above patch and retried and it worked correctly.
