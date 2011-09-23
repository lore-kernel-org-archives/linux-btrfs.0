From: Josef Bacik <josef@redhat.com>
Subject: Re: Btrfs bug with g38867a2 and a question
Date: Fri, 23 Sep 2011 11:34:40 -0400
Message-ID: <4E7CA710.1060606@redhat.com>
References: <4E7A4695.9080106@redhat.com> <20110921231055.GN22205@twin.jikos.cz> <CALiWzOg8CQJF7OfMex1uJTa+doDZ8oufV1nAbos99Z4ev-+xKg@mail.gmail.com> <4E7B423C.2080007@redhat.com> <20110922182222.GA18449@kashmir> <4E7B85B3.6080106@redhat.com> <20110922193007.GA19088@kashmir> <20110922203213.GA19890@kashmir> <20110923125530.GA27417@kashmir> <4E7C9C72.4020109@redhat.com> <20110923153144.GA28744@kashmir>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: dave@jikos.cz, linux-btrfs@vger.kernel.org
To: Mathieu Chouquet-Stringer <mathieu@csetco.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110923153144.GA28744@kashmir>
List-ID: <linux-btrfs.vger.kernel.org>

On 09/23/2011 11:31 AM, Mathieu Chouquet-Stringer wrote:
> On Fri, Sep 23, 2011 at 10:49:22AM -0400, Josef Bacik wrote:
>> Ok I have no idea how this could happen.  Can you mount -o clear_cache
>> and see if it's just the cache that's bad?  Thanks,
> 
> Did that and got this (it's a never ending story, this is from a F16
> alpha boot cd hence stack trace could be different):
> 

Yeah this is a different problem that's fixed upstream, so reboot into
your other newer kernel with -o clear_cache.  Thanks,

Josef
