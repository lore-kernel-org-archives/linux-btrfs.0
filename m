From: Josef Bacik <josef@redhat.com>
Subject: Re: Btrfs bug with g38867a2 and a question
Date: Fri, 23 Sep 2011 10:49:22 -0400
Message-ID: <4E7C9C72.4020109@redhat.com>
References: <20110921185350.GA6618@kashmir> <4E7A4695.9080106@redhat.com> <20110921231055.GN22205@twin.jikos.cz> <CALiWzOg8CQJF7OfMex1uJTa+doDZ8oufV1nAbos99Z4ev-+xKg@mail.gmail.com> <4E7B423C.2080007@redhat.com> <20110922182222.GA18449@kashmir> <4E7B85B3.6080106@redhat.com> <20110922193007.GA19088@kashmir> <20110922203213.GA19890@kashmir> <20110923125530.GA27417@kashmir>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: dave@jikos.cz, linux-btrfs@vger.kernel.org
To: Mathieu Chouquet-Stringer <mathieu@csetco.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110923125530.GA27417@kashmir>
List-ID: <linux-btrfs.vger.kernel.org>

On 09/23/2011 08:55 AM, Mathieu Chouquet-Stringer wrote:
> On Thu, Sep 22, 2011 at 10:32:13PM +0200, Mathieu Chouquet-Stringer wrote:
>> On Thu, Sep 22, 2011 at 09:30:07PM +0200, Mathieu Chouquet-Stringer wrote:
>>> On Thu, Sep 22, 2011 at 03:00:03PM -0400, Josef Bacik wrote:
>>>> Oh wow sorry I sent you the completely wrong patch, I wish I had caught
>>>> your reply earlier.  Can you run with this patch, which is the one I
>>>> meant to give you :).  Thanks,
>>>
>>> No worries, I've applied your patch (seems your thunderbird mangled line
>>> returns) and I'm rebooting...
>>
>> There:
>> http://mathieu.csetco.com/btrfs/btrfs-screenshots.tar
> 
> Just realised I truncated the first line!  It should have been:
> 
> Couldn't find in bitmap offset=20737413120, bytes=57344, search=20765691904, search_bytes=65536, ret=0

Ok I have no idea how this could happen.  Can you mount -o clear_cache
and see if it's just the cache that's bad?  Thanks,

Josef
